--- Diffs gitsigns buffers against the fork point of the branch's GitHub PR, so a PR in a stack shows only its own
--- changes (what GitHub shows) instead of everything since the index.
local M = {}

M.enabled = true

---@type table<string, string|false> merge-base SHA per "<root>:<branch>", or `false` when the branch has no PR.
local merge_bases = {}

---@param root string
---@param callback fun(sha: string|false)
local function find_merge_base(root, callback)
  local function done(sha)
    vim.schedule(function() callback(sha) end)
  end
  vim.system(
    { "gh", "pr", "view", "--json", "baseRefOid", "-q", ".baseRefOid" },
    { cwd = root, text = true },
    function(pr)
      local base_oid = pr.code == 0 and vim.trim(pr.stdout) or ""
      if base_oid == "" then return done(false) end
      local merge_base = { "git", "merge-base", "HEAD", base_oid }
      vim.system(merge_base, { cwd = root, text = true }, function(mb)
        if mb.code == 0 then return done(vim.trim(mb.stdout)) end
        -- The PR's base commit has not been fetched yet.
        vim.system({ "git", "fetch", "--quiet", "origin", base_oid }, { cwd = root }, function()
          vim.system(
            merge_base,
            { cwd = root, text = true },
            function(retry) done(retry.code == 0 and vim.trim(retry.stdout)) end
          )
        end)
      end)
    end
  )
end

---@param bufnr integer
---@param base string?
local function change_base(bufnr, base)
  vim.api.nvim_buf_call(bufnr, function() require("gitsigns").change_base(base, false) end)
end

--- Points the buffer's gitsigns base at its branch's PR fork point, or back at the index when there is no PR.
---@param bufnr integer
function M.apply(bufnr)
  local status = vim.b[bufnr].gitsigns_status_dict
  local head = status and status.head ~= "" and status.head or nil
  vim.b[bufnr].my_pr_base_head = head
  if not head then return end

  local key = status.root .. ":" .. head
  local function on_merge_base(sha)
    merge_bases[key] = sha
    if not M.enabled or not vim.api.nvim_buf_is_loaded(bufnr) or vim.b[bufnr].my_pr_base_head ~= head then return end
    change_base(bufnr, sha or nil)
  end

  -- Always defer: during `on_attach` gitsigns has not created the buffer's cache that `change_base` needs.
  if merge_bases[key] ~= nil then
    vim.schedule(function() on_merge_base(merge_bases[key]) end)
  else
    find_merge_base(status.root, on_merge_base)
  end
end

--- Re-detects the base when the buffer's branch changes (e.g. checking out the next PR in the stack).
---@param bufnr integer
function M.on_update(bufnr)
  if not M.enabled or vim.b[bufnr].my_pr_base_head == nil then return end
  if vim.b[bufnr].gitsigns_head ~= vim.b[bufnr].my_pr_base_head then M.apply(bufnr) end
end

---@param enabled boolean
function M.set_enabled(enabled)
  M.enabled = enabled
  -- Forget cached merge-bases so toggling also picks up new PRs and rebases.
  merge_bases = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.b[bufnr].gitsigns_status_dict then
      if enabled then
        M.apply(bufnr)
      else
        vim.b[bufnr].my_pr_base_head = nil
        change_base(bufnr, nil)
      end
    end
  end
end

return M

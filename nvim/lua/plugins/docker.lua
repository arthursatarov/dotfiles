-- Docker workflow. Everything runs in floating Snacks terminals so you never leave Neovim.
-- Needs the `docker` CLI and (optionally) `lazydocker`:  brew install lazydocker
--
-- Working directory = git root of the current file (or cwd), so `docker compose` finds your compose file.
-- DDEV / Lando users: run `ddev start`, `ddev ssh`, etc. from the plain terminal (<C-/>).

local function root()
  return Snacks.git.get_root() or vim.fn.getcwd()
end

local function float(cmd, opts)
  Snacks.terminal.toggle(cmd, vim.tbl_deep_extend("force", {
    cwd = root(),
    win = { position = "float", width = 0.92, height = 0.9, border = "rounded" },
  }, opts or {}))
end

return {
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>Dd", function() float("lazydocker") end, desc = "Lazydocker (containers, logs)" },
      { "<leader>Du", function() float("docker compose up -d && docker compose ps") end, desc = "compose up -d" },
      { "<leader>DD", function() float("docker compose down") end, desc = "compose down" },
      { "<leader>Dr", function() float("docker compose restart && docker compose ps") end, desc = "compose restart" },
      { "<leader>Dp", function() float("docker compose ps -a") end, desc = "compose ps" },
      { "<leader>Dl", function() float("docker compose logs -f --tail=200") end, desc = "compose logs -f" },
      {
        "<leader>Ds",
        function()
          -- Shell inside a service container: asks for the service name (e.g. php, web, node).
          vim.ui.input({ prompt = "Service name: ", default = vim.g.docker_default_service or "php" }, function(svc)
            if not svc or svc == "" then return end
            float(("docker compose exec %s sh -c 'command -v bash >/dev/null && exec bash || exec sh'"):format(svc))
          end)
        end,
        desc = "Shell in a service container",
      },
      {
        "<leader>Dc",
        function()
          -- Run any command inside a service, e.g. `composer install`, `drush cr`, `wp cache flush`.
          vim.ui.input({ prompt = "service command> ", default = "php composer install" }, function(line)
            if not line or line == "" then return end
            float("docker compose exec " .. line)
          end)
        end,
        desc = "compose exec <service> <command>",
      },
    },
  },
}

-- Extra filetype detection for the CMS stack.

vim.filetype.add({
  extension = {
    -- Drupal PHP files
    module = "php",
    theme = "php",
    install = "php",
    profile = "php",
    engine = "php",
    inc = "php",
    -- Nunjucks has no dedicated parser/LSP; `htmldjango` gives sensible
    -- {% %} / {{ }} highlighting via Vim's built-in syntax and works with emmet/html LSP.
    njk = "htmldjango",
    nunjucks = "htmldjango",
    -- Twig is detected natively (*.twig, *.html.twig) -> filetype "twig".
  },
  filename = {
    [".stylelintrc"] = "json",
    [".eslintrc"] = "json",
    [".prettierrc"] = "json",
    ["phpcs.xml"] = "xml",
    ["phpcs.xml.dist"] = "xml",
    [".phpcs.xml"] = "xml",
    ["phpunit.xml.dist"] = "xml",
    -- Docker compose files (enables docker_compose_language_service)
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    -- Drupal: *.info.yml, *.routing.yml, *.services.yml are plain YAML already.
    -- Docker compose variants
    ["compose%..*%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
  },
})

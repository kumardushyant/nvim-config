local function get_jdtls()
  local mason_registry = require("mason-registry")
  local jdtls = mason_registry.get_package("jdtls")
  local jdtls_path = jdtls:get_install_path()
  local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  local SYSTEM = "win"
  local config = jdtls_path .. "/config_" .. SYSTEM
  local lombok = jdtls_path .. "/lombok.jar"
  return launcher, config, lombok
end

local function get_bundles()
  local mason_registry = require("mason-registry")
  local java_debug = mason_registry.get_package("java-debug-adapter")
  local java_debug_path = java_debug:get_install_path()

  local bundles = {
    vim.fn.glob(java_debug_path .. "/extensions/server/com.microsoft.java.debug.plugin_*.jar", 1),
  }

  local java_test = mason_registry.get_package("java-test")
  local java_test_path = java_test:get_install_path()
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))

  return bundles
end

local function get_workspace()
  local home = os.getenv "USERPROFILE"
  local workspace_path = home .. "/workspace"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  local workspace_dir = workspace_path .. project_name

  return workspace_dir
end

local function java_keymaps()
  vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)")
  vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
  vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

  vim.keymap.set("n", "<leader>Jo", "<Cmd> lua require('jdtls').organize_imports()<CR>", { noremap = true, silent = true, desc = "Organize imports" })
  vim.keymap.set("n", "<leader>Ja", "<Cmd> lua require('jdtls').code_action()<CR>", { noremap = true, silent = true, desc = "Code action" })
  vim.keymap.set("n", "<leader>Jx", "<Cmd> lua require('jdtls').extract_variable()<CR>", { noremap = true, silent = true, desc = "Extract variable" })
  vim.keymap.set("v", "<leader>Jx", "<Esc><Cmd> lua require('jdtls').extract_variable(true)<CR>", { noremap = true, silent = true, desc = "Extract variable" })
  vim.keymap.set("n", "<leader>JC", "<Cmd> lua require('jdtls').extract_constant()<CR>", { noremap = true, silent = true, desc = "Extract constant" })
  vim.keymap.set("v", "<leader>JC", "<Esc><Cmd> lua require('jdtls').extract_constant(true)<CR>", { noremap = true, silent = true, desc = "Extract constant" })
  vim.keymap.set("n", "<leader>Jt", "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { noremap = true, silent = true, desc = "Test nearest method" })
  vim.keymap.set("v", "<leader>Jt", "<Esc><Cmd> lua require('jdtls').test_nearest_method(true)<CR>", { noremap = true, silent = true, desc = "Test nearest method" })
  vim.keymap.set("n", "<leader>JT", "<Cmd> lua require('jdtls').test_class()<CR>", { noremap = true, silent = true, desc = "Test class" })
  vim.keymap.set("v", "<leader>JT", "<Esc><Cmd> lua require('jdtls').test_class(true)<CR>", { noremap = true, silent = true, desc = "Test class" })
  vim.keymap.set("n", "<leader>Jr", "<Cmd> lua require('jdtls').rename()<CR>", { noremap = true, silent = true, desc = "Rename" })
  vim.keymap.set("n", "<leader>Jf", "<Cmd> lua require('jdtls').formatting()<CR>", { noremap = true, silent = true, desc = "Formatting" })
  vim.keymap.set("n", "<leader>Ji", "<Cmd> lua require('jdtls').implement_methods()<CR>", { noremap = true, silent = true, desc = "Implement methods" })
  vim.keymap.set("n", "<leader>Jd", "<Cmd> lua require('jdtls').show_documentation()<CR>", { noremap = true, silent = true, desc = "Show documentation" })
  vim.keymap.set("n", "<leader>Jc", "<Cmd> JdtCompile <CR>", { noremap = true, silent = true, desc = "Compile" })
  vim.keymap.set("n", "<leader>Ju", "<Cmd> JdtUpdateConfig <CR>", { noremap = true, silent = true, desc = "Update project config" })
end

local function setup_jdtls()
  local jdtls = require("jdtls")
  
  local launcher, config, lombok = get_jdtls()
  local workspace_dir = get_workspace()

  local bundles = get_bundles()

  local root_dir = jdtls.setup.find_root {
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "settings.gradle",
    "WORKSPACE",
  }

  local capabilities = {
    workspace = {
      configuration = true,
    },
    textDocument = {
      completion = {
        snippetSupport = false,
      },
    },
  }

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx2G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '-javaagent:' .. lombok,
    '-jar', launcher, '-configuration', config, '-data', workspace_dir,
  }

  local settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java/google-java-format.xml",
          profile = "GoogleStyle",
        },
        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
        },
        signatureHelp = {
          enabled = true,
        },
        contentProvider = {
          preferred = "fernflower",
        },
        gradle = {
          downloadSources = true,
        },
        saveActions = {
          organizeImports = true,
        },
        completion = {
          favoriteStaticMembers = {
            "org.junit.Assert.*",
            "org.mockito.Mockito.*",
            "org.hamcrest.MatcherAssert.assertThat",
            "java.util.Objects.requireNonNull",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "java.util.Objects.requireNonNullElse",
          },
          filteredTypes = {
            "com.sun.*",
            "java.awt.*",
            "io.micrometer.shaded.*",
            "jdk.*",
            "sun.*",
          },
          importOrder = {
            "java",
            "javax",
            "org",
            "com",
            "io",
            "net",
            "sun",
            "com.sun",
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGenerations = {
            tostring = {
              template = "${object.className}[${member.name()}=${member.value()}, ${otherMembers}]",
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          referencesCodeLens = {
            enabled = true,
          },
          inlayHints = {
            enabled = true,
            parameterHints = {
              enabled = true,
              onlyForTrailingComma = false,
            },
            typeHints = {
              enabled = true,
              primitiveTypeHints = true,
              referenceTypeHints = true,
            },
            chainingHints = {
              enabled = true,
            },
            maxLineLength = 120,
            showStaticMethodReceiver = true,
            showVirtualMethodReceiver = true,
            showParameterHints = true,
            showTypeHints = true,
            showChainingHints = true,
          },
        },
      }
    }
  }

  local init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  local on_attach = function(client, bufnr)
    java_keymaps()
    require("jdtls.dap").setup_dap()
    -- require("jdtls.dap").setup_dap_main_class_configs()
    require("jdtls.setup").add_commands()
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.java" },
      callback = function()
        local _, _ = pcall(vim.lsp.codelens.refresh)
      end
    })
  end

  local jdconfig = {
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    init_options = init_options,
    on_attach = on_attach,
  }

  require("jdtls").start_or_attach(jdconfig)
end

return {
  setup_jdtls = setup_jdtls,
}


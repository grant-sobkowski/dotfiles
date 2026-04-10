-- Claude CLI provider for codegpt-ng.nvim
local Job = require("plenary.job")
local Render = require("codegpt.template_render")
local Utils = require("codegpt.utils")
local Api = require("codegpt.api")
local Config = require("codegpt.config")

local M = {}

local function generate_prompt(command, cmd_opts, command_args, text_selection)
	local system_message =
		Render.render(command, cmd_opts.system_message_template, command_args, text_selection, cmd_opts, true)
	local user_message = Render.render(command, cmd_opts.user_message_template, command_args, text_selection, cmd_opts)

	-- Combine system and user messages
	local full_prompt = ""
	if system_message and system_message ~= "" then
		full_prompt = system_message .. "\n\n" .. user_message
	else
		full_prompt = user_message
	end

	return full_prompt
end

function M.make_request(command, cmd_opts, command_args, text_selection, is_stream)
	-- Note: is_stream parameter is ignored since claude CLI doesn't support streaming
	return generate_prompt(command, cmd_opts, command_args, text_selection)
end

function M.make_call(prompt, cb)
	Api.run_started_hook()

	-- Explicitly pass all necessary environment variables
	local env = vim.fn.environ()
	-- Ensure critical AWS/Claude variables are set
	env.AWS_CA_BUNDLE = os.getenv("AWS_CA_BUNDLE") or env.AWS_CA_BUNDLE
	env.AWS_REGION = os.getenv("AWS_REGION") or env.AWS_REGION
	env.AWS_PROFILE = os.getenv("AWS_PROFILE") or env.AWS_PROFILE
	env.ANTHROPIC_MODEL = os.getenv("ANTHROPIC_MODEL") or env.ANTHROPIC_MODEL
	env.CLAUDE_CODE_USE_BEDROCK = os.getenv("CLAUDE_CODE_USE_BEDROCK") or env.CLAUDE_CODE_USE_BEDROCK

	Job:new({
		command = "claude",
		args = {}, -- Pass prompt via stdin instead
		writer = prompt, -- Send prompt through stdin
		env = env,
		on_exit = vim.schedule_wrap(function(j, return_val)
			Api.run_finished_hook()

			if return_val ~= 0 then
				local stderr = table.concat(j:stderr_result(), "\n")
				vim.notify("Claude CLI Error: " .. stderr, vim.log.levels.ERROR)
				return
			end

			local response = table.concat(j:result(), "\n")
			if response == nil or response == "" then
				vim.notify("Claude CLI: Empty response", vim.log.levels.ERROR)
				return
			end

			local bufnr = vim.api.nvim_get_current_buf()
			if Config.opts.clear_visual_selection then
				vim.api.nvim_buf_set_mark(bufnr, "<", 0, 0, {})
				vim.api.nvim_buf_set_mark(bufnr, ">", 0, 0, {})
			end

			cb(Utils.parse_lines(response))
		end),
	}):start()
end

function M.get_models()
	vim.notify("Claude CLI: Model listing not implemented", vim.log.levels.WARN)
end

return M

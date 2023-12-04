-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "x", '"_x', opts)
-- Delete a word backwards
keymap("n", "dw", 'vb"_d', opts)
-- Increment/decrement
keymap("n", "+", "<C-a>", opts)
keymap("n", "-", "<C-x>", opts)
keymap("n", "<leader>d", ":DiffviewOpen<cr>", opts)
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)
keymap("x", "<leader>p", [["_dP]], opts)
vim.keymap.del({ "i", "n", "x", "s" }, "<C-s>")
keymap({ "i", "x", "n", "s" }, "<C-s>", ":w<cr>", opts)

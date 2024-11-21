// src/MockERC20.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "cctp-foundry/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "cctp-foundry/lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract MockERC20 is IERC20, IERC20Metadata {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    // ERC20 Metadata functions
    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    // ERC20 Standard functions
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        require(to != address(0), "MockERC20: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "MockERC20: transfer amount exceeds balance");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        require(spender != address(0), "MockERC20: approve to the zero address");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external override returns (bool) {
        require(from != address(0), "MockERC20: transfer from the zero address");
        require(to != address(0), "MockERC20: transfer to the zero address");
        require(_balances[from] >= amount, "MockERC20: transfer amount exceeds balance");
        require(_allowances[from][msg.sender] >= amount, "MockERC20: transfer amount exceeds allowance");

        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // Custom functions for testing
    function mint(address to, uint256 amount) external {
        require(to != address(0), "MockERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) external {
        require(from != address(0), "MockERC20: burn from the zero address");
        require(_balances[from] >= amount, "MockERC20: burn amount exceeds balance");

        _balances[from] -= amount;
        _totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;
// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

contract ERC20 {


    address owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    error Invalid_Address();
    error Insufficient_Funds();
    error InsufficientAllowance();
    error OnlyOwner_Allowed();
    error Invalid_Amount();

    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Minted(address indexed _to, uint256 _value);

    modifier onlyOwner() {
        if(msg.sender != owner) revert OnlyOwner_Allowed();
        _;
    }

    constructor() {
        _name = "ERC20";
        _symbol = "ERC";
        _decimals = 18;
        _totalSupply = 1000000 * 10 ** uint256(_decimals);
        owner = msg.sender;
        balances[owner] = _totalSupply;
    }

    

    function mint(address _to, uint256 _value) public onlyOwner returns (bool success) {
        if(_to == address(0)) revert Invalid_Address();
        if(_value <= 0) revert Invalid_Amount();
        _totalSupply += _value;
        balances[_to] += _value;

        success = true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        if(_owner == address(0)) revert Invalid_Address();
        balance = balances[_owner];

    }   

    function approve(address _spender, uint256 _value) public returns (bool success) {
        if(_spender == address(0)) revert Invalid_Address();
        if(balances[msg.sender] < _value) revert Insufficient_Funds();
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        remaining = allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if(_to == address(0)) revert Invalid_Address();
        if(_value > balances[msg.sender]) revert Insufficient_Funds();

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        success = true;
        
    }
    

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(msg.sender == address(0)) revert Invalid_Address();
        if(_to == address(0)) revert Invalid_Address();
        if(_from == address(0)) revert Invalid_Address();
        if(_value > balances[_from]) revert Insufficient_Funds();

        if(allowances[_from][msg.sender] >= _value){
            balances[_from] -= _value;
            allowances[_from][msg.sender] -= _value;
            balances[_to] += _value;

            emit Transfer(_from, _to, _value);
            success = true;
        } else {
            revert InsufficientAllowance();
        }

    }
    
    
}

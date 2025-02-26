// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.28;

contract ERC20 {

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    address owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    error InvalidAddress();
    error InsufficientFunds();
    error InsufficientAllowance();
    error OnlyOwnerAllowed();
    error InvalidAmount();

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Minted(address indexed _to, uint256 _value);

    modifier onlyOwner() {
        if(msg.sender != owner) revert OnlyOwnerAllowed();
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

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        if(_owner == address(0)) revert InvalidAddress();
        balance = balances[_owner];

    }   

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if(_to == address(0)) revert InvalidAddress();
        if(_value > balances[msg.sender]) revert InsufficientFunds();

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        success = true;
        
    }


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(msg.sender == address(0)) revert InvalidAddress();
        if(_to == address(0)) revert InvalidAddress();
        if(_from == address(0)) revert InvalidAddress();
        if(_value > balances[_from]) revert InsufficientFunds();
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


    function approve(address _spender, uint256 _value) public returns (bool success) {
        if(_spender == address(0)) revert InvalidAddress();
        if(balances[msg.sender] < _value) revert InsufficientFunds();
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        remaining = allowances[_owner][_spender];
    }

    function mint(address _to, uint256 _value) public onlyOwner returns (bool success) {
        if(_to == address(0)) revert InvalidAddress();
        if(_value <= 0) revert InvalidAmount();

        _totalSupply += _value;
        balances[_to] += _value;

        success = true;
    }
    
}

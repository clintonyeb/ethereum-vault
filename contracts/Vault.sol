pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2; // To be able to return a list of `struct`

contract Vault {
  // state variables

  // events
  
  // complex types
  struct Password {
    uint index;
    bytes32 name;
    bytes32 encryptedPassword;
  }

  struct Account {
    bool created;
    Password[] passwords;
  }

  // mappings
  mapping (address => Account) accounts;

  // modifiers

  modifier accountCreated() {
    require(
      accounts[msg.sender].created,
      "Please create an account first."
    );
    _;
  }

  // constructor

  // private variables

  // external methods
  
   // public methods

  /// Creates a new user account
  function createAccount() public returns(bool) {
    address owner = msg.sender;

    require(
      !accounts[owner].created,
      "User account already exists."
    );

    accounts[owner].created = true;
    return true;
  }

  /// Adds a name and an encrypted password
  /// Password must be encrypted by user's public key before sending.
  function addPassword(bytes32 _name, bytes32 _encryptedPassword) public accountCreated returns (bool) {
    address owner = msg.sender;

    uint index = accounts[owner].passwords.length;

    accounts[owner].passwords.push(Password({
      index: index,
      name: _name,
      encryptedPassword: _encryptedPassword
    }));

    assert(index == accounts[owner].passwords.length);

    return true;
  }

  /// Gets a list of all passwords of a user account
  function getPasswords() public view accountCreated returns (Password[]) {
    return accounts[msg.sender].passwords;
  }

  /// Gets the name and encrypted password at an index
  function getPassword(uint index) public view accountCreated returns (bytes32 name, bytes32 encryptedPassword) {
    Password[] storage passwords = accounts[msg.sender].passwords;

    require(
      index < passwords.length,
      "Invalid index provided"
    );
  
    return (passwords[index].name, passwords[index].encryptedPassword);
  }

}
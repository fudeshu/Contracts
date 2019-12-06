/**
 *Submitted for verification at Etherscan.io on 2019-04-10
*/

// File: openzeppelin-solidity/contracts/introspection/IERC165.sol

pragma solidity ^0.4.23;

/**
 * @title IERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface IERC165 {
    /**
     * @notice Query if a contract implements an interface
     * @param interfaceId The interface identifier, as specified in ERC-165
     * @dev Interface identification is specified in ERC-165. This function
     * uses less than 30,000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol

pragma solidity ^0.4.23;


/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, string indexed tokenId);
    event Approval(address indexed owner, address indexed approved, string indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) public view returns (uint256 balance);
    function ownerOf(string tokenId) public view returns (address owner);

    function approve(address to, string tokenId) public;
    function getApproved(string tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);

    function transferFrom(address from, address to, string tokenId) public;
    function safeTransferFrom(address from, address to, string tokenId) public;

    function safeTransferFrom(address from, address to, string tokenId, bytes memory data) public;
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol

pragma solidity ^0.4.23;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract IERC721Receiver {
    /**
     * @notice Handle the receipt of an NFT
     * @dev The ERC721 smart contract calls this function on the recipient
     * after a `safeTransfer`. This function MUST return the function selector,
     * otherwise the caller will revert the transaction. The selector to be
     * returned can be obtained as `this.onERC721Received.selector`. This
     * function MAY throw to revert and reject the transfer.
     * Note: the ERC721 contract address is always the message sender.
     * @param operator The address which called `safeTransferFrom` function
     * @param from The address which previously owned the token
     * @param tokenId The NFT identifier which is being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
     */
    function onERC721Received(address operator, address from, string tokenId, bytes memory data)
    public returns (bytes4);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.4.23;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/utils/Address.sol

pragma solidity ^0.4.23;

/**
 * Utility library of inline functions on addresses
 */
library Address {
    /**
     * Returns whether the target address is a contract
     * @dev This function will return false if invoked during the constructor of a contract,
     * as the code is not actually created until after the constructor finishes.
     * @param account address of the account to check
     * @return whether the target address is a contract
     */
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

// File: ethereum/dapp-bin/library/stringUtils.sol

library StringUtils {
    /// @dev Does a byte-by-byte lexicographical comparison of two strings.
    /// @return a negative number if `_a` is smaller, zero if they are equal
    /// and a positive numbe if `_b` is smaller.
    function compare(string _a, string _b) internal pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string _a, string _b) internal pure returns (bool) {
        return compare(_a, _b) == 0;
    }
    /// @dev Finds the index of the first occurrence of _needle in _haystack
    function indexOf(string _haystack, string _needle) internal pure returns (int)
    {
    	bytes memory h = bytes(_haystack);
    	bytes memory n = bytes(_needle);
    	if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
    		return -1;
    	else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
    		return -1;									
    	else
    	{
    		uint subindex = 0;
    		for (uint i = 0; i < h.length; i ++)
    		{
    			if (h[i] == n[0]) // found the first char of b
    			{
    				subindex = 1;
    				while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
    				{
    					subindex++;
    				}	
    				if(subindex == n.length)
    					return int(i);
    			}
    		}
    		return -1;
    	}	
    }
}

// File: openzeppelin-solidity/contracts/introspection/ERC165.sol

pragma solidity ^0.4.23;


/**
 * @title ERC165
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract ERC165 is IERC165 {
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    /**
     * 0x01ffc9a7 ===
     *     bytes4(keccak256('supportsInterface(bytes4)'))
     */

    /**
     * @dev a mapping of interface id to whether or not it's supported
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
     * @dev A contract implementing SupportsInterfaceWithLookup
     * implement ERC165 itself
     */
    constructor () internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev implement supportsInterface(bytes4) using a lookup table
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev internal method for registering an interface
     */
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _supportedInterfaces[interfaceId] = true;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol

pragma solidity ^0.4.23;






/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (string => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (string => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => uint256) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    /*
     * 0x80ac58cd ===
     *     bytes4(keccak256('balanceOf(address)')) ^
     *     bytes4(keccak256('ownerOf(uint256)')) ^
     *     bytes4(keccak256('approve(address,uint256)')) ^
     *     bytes4(keccak256('getApproved(uint256)')) ^
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
     *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
     *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
     */

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    /**
     * @dev Gets the balance of the specified address
     * @param owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0));
        return _ownedTokensCount[owner];
    }

    /**
     * @dev Gets the owner of the specified token ID
     * @param tokenId uint256 ID of the token to query the owner of
     * @return owner address currently marked as the owner of the given token ID
     */
    function ownerOf(string tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0));
        return owner;
    }

    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param to address to be approved for the given token ID
     * @param tokenId uint256 ID of the token to be approved
     */
    function approve(address to, string tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to query the approval of
     * @return address currently approved for the given token ID
     */
    function getApproved(string tokenId) public view returns (address) {
        require(_exists(tokenId));
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf
     * @param to operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender);
        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address
     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function transferFrom(address from, address to, string tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));

        _transferFrom(from, to, tokenId);
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     *
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function safeTransferFrom(address from, address to, string tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(address from, address to, string tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data));
    }

    /**
     * @dev Returns whether the specified token exists
     * @param tokenId uint256 ID of the token to query the existence of
     * @return whether the token exists
     */
    function _exists(string tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     *    is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, string tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Internal function to mint a new token
     * Reverts if the given token ID already exists
     * @param to The address that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, string tokenId) internal {
        require(to != address(0));
        require(!_exists(tokenId));

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address owner, string tokenId) internal {
        require(ownerOf(tokenId) == owner);

        _clearApproval(tokenId);

        _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(string tokenId) internal {
        _burn(ownerOf(tokenId), tokenId);
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function _transferFrom(address from, address to, string tokenId) internal {
        require(ownerOf(tokenId) == from);
        require(to != address(0));

        _clearApproval(tokenId);

        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Internal function to invoke `onERC721Received` on a target address
     * The call is not executed if the target address is not a contract
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, string tokenId, bytes memory _data)
        internal returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    /**
     * @dev Private function to clear current approval of a given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _clearApproval(string tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol

pragma solidity ^0.4.23;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract IERC721Enumerable is IERC721 {
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (string tokenId);

    function tokenByIndex(uint256 index) public view returns (string);
}

// File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol

pragma solidity ^0.4.23;




/**
 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => string[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(string => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    string[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(string => uint256) private _allTokensIndex;

    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
    /**
     * 0x780e9d63 ===
     *     bytes4(keccak256('totalSupply()')) ^
     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
     *     bytes4(keccak256('tokenByIndex(uint256)'))
     */

    /**
     * @dev Constructor function
     */
    constructor () public {
        // register the supported interface to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    /**
     * @dev Gets the token ID at a given index of the tokens list of the requested owner
     * @param owner address owning the tokens list to be accessed
     * @param index uint256 representing the index to be accessed of the requested tokens list
     * @return uint256 token ID at the given index of the tokens list owned by the requested address
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (string) {
        require(index < balanceOf(owner));
        return _ownedTokens[owner][index];
    }

    /**
     * @dev Gets the total amount of tokens stored by the contract
     * @return uint256 representing the total amount of tokens
     */
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev Gets the token ID at a given index of all the tokens in this contract
     * Reverts if the index is greater or equal to the total number of tokens
     * @param index uint256 representing the index to be accessed of the tokens list
     * @return uint256 token ID at the given index of the tokens list
     */
    function tokenByIndex(uint256 index) public view returns (string) {
        require(index < totalSupply());
        return _allTokens[index];
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function _transferFrom(address from, address to, string tokenId) internal {
        super._transferFrom(from, to, tokenId);

        _removeTokenFromOwnerEnumeration(from, tokenId);

        _addTokenToOwnerEnumeration(to, tokenId);
    }

    /**
     * @dev Internal function to mint a new token
     * Reverts if the given token ID already exists
     * @param to address the beneficiary that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, string tokenId) internal {
        super._mint(to, tokenId);

        _addTokenToOwnerEnumeration(to, tokenId);

        _addTokenToAllTokensEnumeration(tokenId);
    }

    /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address owner, string tokenId) internal {
        super._burn(owner, tokenId);

        _removeTokenFromOwnerEnumeration(owner, tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[tokenId] = 0;

        _removeTokenFromAllTokensEnumeration(tokenId);
    }

    /**
     * @dev Gets the list of token IDs of the requested owner
     * @param owner address owning the tokens
     * @return uint256[] List of token IDs owned by the requested address
     */
    function _tokensOfOwner(address owner) internal view returns (string[] storage) {
        return _ownedTokens[owner];
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, string tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(string tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, string tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            string memory lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        _ownedTokens[from].length--;

        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
        // lasTokenId, or just over the end of the array if the token was the last one).
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(string tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length.sub(1);
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        string memory lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol

pragma solidity ^0.4.23;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(string tokenId) external view returns (string memory);
}

// File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol

pragma solidity ^0.4.23;




contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Optional mapping for token URIs
    mapping(string => string) private _tokenURIs;

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    /**
     * 0x5b5e139f ===
     *     bytes4(keccak256('name()')) ^
     *     bytes4(keccak256('symbol()')) ^
     *     bytes4(keccak256('tokenURI(uint256)'))
     */

    /**
     * @dev Constructor function
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    /**
     * @dev Gets the token name
     * @return string representing the token name
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Gets the token symbol
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns an URI for a given token ID
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     */
    function tokenURI(string tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return _tokenURIs[tokenId];
    }

    /**
     * @dev Internal function to set the token URI for a given token
     * Reverts if the token ID does not exist
     * @param tokenId uint256 ID of the token to set its URI
     * @param uri string URI to assign
     */
    function _setTokenURI(string tokenId, string memory uri) internal {
        require(_exists(tokenId));
        _tokenURIs[tokenId] = uri;
    }

    /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned by the msg.sender
     */
    function _burn(address owner, string tokenId) internal {
        super._burn(owner, tokenId);

        // Clear metadata (if any)
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

// File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol

pragma solidity ^0.4.23;




/**
 * @title Full ERC721 Token
 * This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }
}

// File: openzeppelin-solidity/contracts/access/Roles.sol

pragma solidity ^0.4.23;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}

// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol

pragma solidity ^0.4.23;


contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender));
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

// File: openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol

pragma solidity ^0.4.23;



/**
 * @title ERC721Mintable
 * @dev ERC721 minting logic
 */
contract ERC721Mintable is ERC721, MinterRole {
    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, string tokenId) public onlyMinter returns (bool) {
        _mint(to, tokenId);
        return true;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC721/ERC721MetadataMintable.sol

pragma solidity ^0.4.23;




/**
 * @title ERC721MetadataMintable
 * @dev ERC721 minting logic with metadata
 */
contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @param tokenURI The token URI of the minted token.
     * @return A boolean that indicates if the operation was successful.
     */
    function mintWithTokenURI(address to, string tokenId, string memory tokenURI) public onlyMinter returns (bool) {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return true;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol

pragma solidity ^0.4.23;


/**
 * @title ERC721 Burnable Token
 * @dev ERC721 Token that can be irreversibly burned (destroyed).
 */
contract ERC721Burnable is ERC721 {
    /**
     * @dev Burns a specific ERC721 token.
     * @param tokenId uint256 id of the ERC721 token to be burned.
     */
    function burn(string tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));
        _burn(tokenId);
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.4.23;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return (msg.sender == _owner) || (tx.origin == _owner);
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/key/BBTokenBase.sol

pragma solidity ^0.4.23;



contract ADToken is Ownable {
    function addAd(address to, string treeId, bytes9 adId) public onlyOwner;
    function addAds(address to, string treeId, bytes9[] memory adIds) public onlyOwner;
    function transferAd(address from, address to, bytes9 adId) public;
    function transferAds(address from, address to, bytes9[] memory adIds) public;
    function transferFroms(address from, address to, bytes9[] adIds) public;
    function keyMintAdd(address to, string treeId, bytes9 adId) public onlyOwner;
    function keyMintAddMultiple(address to, string treeId, bytes9[] memory adIds) public onlyOwner;
    function keyExchange(bytes9 adId) public onlyOwner;
    function keyExchangeMultiple(bytes9[] memory adIds) public onlyOwner;
}

contract DGToken is Ownable {
    function addGene(address to, string treeId, uint256 geneId) public onlyOwner;
    function addGenes(address to, string treeId, uint256[] geneIds) public onlyOwner;
    function transferGene(address from, address to, uint256 geneId) public;
    function transferGenes(address from, address to, uint256[] geneIds) public;
    function transferFroms(address from, address to, uint256[] geneIds) public;
    function keyMint(address to, string treeId, uint256 geneId) public onlyOwner;
    function keyMintMultiple(address to, string treeId, uint256[] geneIds) public onlyOwner;
    function keyExchange(uint256 geneId) public onlyOwner;
    function keyExchangeMultiple(uint256[] geneIds) public onlyOwner;
}

contract RGToken is Ownable {
    function addGene(address to, string treeId, uint256 geneId) public onlyOwner;
    function addGenes(address to, string treeId, uint256[] geneIds) public onlyOwner;
    function transferGene(address from, address to, uint256 geneId) public;
    function transferGenes(address from, address to, uint256[] geneIds) public;
    function transferFroms(address from, address to, uint256[] geneIds) public;
    function keyMint(address to, string treeId, uint256 geneId) public onlyOwner;
    function keyMintMultiple(address to, string treeId, uint256[] geneIds) public onlyOwner;
    function keyExchange(uint256 geneId) public onlyOwner;
    function keyExchangeMultiple(uint256[] geneIds) public onlyOwner;
}


contract BBTokenBase is ERC721Full, ERC721Mintable, ERC721MetadataMintable, ERC721Burnable, Ownable {
    using SafeMath for uint256;
    uint256 internal _itemsIndex = 1;
    uint256 internal _itemsLimit = 600000;
    mapping(string => bytes9[]) internal _ownedAds;
    mapping(bytes9 => uint256) internal _ownedAdsIndex;
    mapping(bytes9 => address) internal _adOwner;
    ADToken internal _adToken;
    
    uint256 internal _dominantGenesTreeLimit = 6;
    mapping(string => uint256[]) internal _ownedDominantGenes;
    mapping(uint256 => uint256) internal _ownedDominantGenesIndex;
    mapping(uint256 => address) internal _dominantGeneOwner;
    DGToken internal _dgToken;
    
    uint256 internal _recessiveGenesTreeLimit = 4;
    mapping(string => uint256[]) internal _ownedRecessiveGenes;
    mapping(uint256 => uint256) internal _ownedRecessiveGenesIndex;
    mapping(uint256 => address) internal _recessiveGeneOwner;
    RGToken internal _rgToken;

    function mintUniqueTokenTo(address to, string treeId, string memory tokenURI) internal onlyOwner {
        require(_itemsIndex <= _itemsLimit);
        _mint(to, treeId);
        _setTokenURI(treeId, tokenURI);

        _itemsIndex = _itemsIndex.add(1);
    }

    function ownedAds(string treeId) public view returns (bytes9[])  {
        require(_exists(treeId));
        return _ownedAds[treeId];
    } 

    function addAdTo(address to, string treeId, bytes9 adId) internal {
        require(ownerOf(treeId) == to);
        require(_adOwner[adId] == address(0));
        _ownedAdsIndex[adId] = _ownedAds[treeId].length;
        _ownedAds[treeId].push(adId);
        _adOwner[adId] = to;
    }

    function removeAdTo(address from, string treeId, bytes9 adId) internal {
        require(ownerOf(treeId) == from);
        require(_adOwner[adId] == from);
        uint256 lastAdIndex = _ownedAds[treeId].length.sub(1);
        uint256 adIndex = _ownedAdsIndex[adId];
        require(_ownedAds[treeId][adIndex] == adId);
        if (adIndex != lastAdIndex) {
            bytes9 lastAdId = _ownedAds[treeId][lastAdIndex];
            _ownedAds[treeId][adIndex] = lastAdId;
            _ownedAdsIndex[lastAdId] = adIndex;
        }
        _ownedAds[treeId].length--;
        _adOwner[adId] = address(0);
    }
    
    function removeAdTo(string treeId) internal {
        bytes9[] storage adIds =  _ownedAds[treeId];
        for (uint i = 0; i < adIds.length; i++) {
            _ownedAdsIndex[adIds[i]] = 0;
            _adOwner[adIds[i]] = address(0);
        }
        _ownedAds[treeId].length = 0;
    }
    
    function ownedDominantGenes(string treeId) public view returns (uint256[])  {
        require(_exists(treeId));
        return _ownedDominantGenes[treeId];
    } 

    function addDominantGeneTo(address to, string treeId, uint256 geneId) internal {
        require(ownerOf(treeId) == to);
        require(_dominantGeneOwner[geneId] == address(0));
        require(_ownedDominantGenes[treeId].length < _dominantGenesTreeLimit);
        _ownedDominantGenesIndex[geneId] = _ownedDominantGenes[treeId].length;
        _ownedDominantGenes[treeId].push(geneId);
        _dominantGeneOwner[geneId] = to;
    }

    function removeDominantGeneTo(address from, string treeId, uint256 geneId) internal {
        require(ownerOf(treeId) == from);
        require(_dominantGeneOwner[geneId] == from);
        uint256 lastGeneIndex = _ownedDominantGenes[treeId].length.sub(1);
        uint256 geneIndex = _ownedDominantGenesIndex[geneId];
        require(_ownedDominantGenes[treeId][geneIndex] == geneId);
        if (geneIndex != lastGeneIndex) {
            uint256 lastGeneId = _ownedDominantGenes[treeId][lastGeneIndex];
            _ownedDominantGenes[treeId][geneIndex] = lastGeneId;
            _ownedDominantGenesIndex[lastGeneId] = geneIndex;
        }
        _ownedDominantGenes[treeId].length--;
        _dominantGeneOwner[geneId] = address(0);
    }

    function removeDominantGeneTo(string treeId) internal {
        uint256[] storage geneIds =  _ownedDominantGenes[treeId];
        for (uint i = 0; i < geneIds.length; i++) {
            _ownedDominantGenesIndex[geneIds[i]] = 0;
            _dominantGeneOwner[geneIds[i]] = address(0);
        }
        _ownedDominantGenes[treeId].length = 0;
    }

    function ownedRecessiveGenes(string treeId) public view returns (uint256[])  {
        require(_exists(treeId));
        return _ownedRecessiveGenes[treeId];
    } 

    function addRecessiveGeneTo(address to, string treeId, uint256 geneId) internal {
        require(ownerOf(treeId) == to);
        require(_recessiveGeneOwner[geneId] == address(0));
        require(_ownedRecessiveGenes[treeId].length < _recessiveGenesTreeLimit);
        _ownedRecessiveGenesIndex[geneId] = _ownedRecessiveGenes[treeId].length;
        _ownedRecessiveGenes[treeId].push(geneId);
        _recessiveGeneOwner[geneId] = to;
    }

    function removeRecessiveGeneTo(address from, string treeId, uint256 geneId) internal {
        require(ownerOf(treeId) == from);
        require(_recessiveGeneOwner[geneId] == from);
        uint256 lastGeneIndex = _ownedRecessiveGenes[treeId].length.sub(1);
        uint256 geneIndex = _ownedRecessiveGenesIndex[geneId];
        require(_ownedRecessiveGenes[treeId][geneIndex] == geneId);
        if (geneIndex != lastGeneIndex) {
            uint256 lastGeneId = _ownedRecessiveGenes[treeId][lastGeneIndex];
            _ownedRecessiveGenes[treeId][geneIndex] = lastGeneId;
            _ownedRecessiveGenesIndex[lastGeneId] = geneIndex;
        }
        _ownedRecessiveGenes[treeId].length--;
        _recessiveGeneOwner[geneId] = address(0);
    }

    function removeRecessiveGeneTo(string treeId) internal {
        uint256[] storage geneIds =  _ownedRecessiveGenes[treeId];
        for (uint i = 0; i < geneIds.length; i++) {
            _ownedRecessiveGenesIndex[geneIds[i]] = 0;
            _recessiveGeneOwner[geneIds[i]] = address(0);
        }
        _ownedRecessiveGenes[treeId].length = 0;
    }
}

contract BBTokenImpl is BBTokenBase {
    
    function addAd(address to, string treeId, bytes9 adId) public onlyOwner {
        require(ownerOf(treeId) == to);
        _adToken.addAd(to, treeId, adId);
        addAdTo(to, treeId, adId);
    }
    
    function addAds(address to, string treeId, bytes9[] adIds) public onlyOwner {
        require(ownerOf(treeId) == to);
        _adToken.addAds(to, treeId, adIds);
        for (uint i = 0; i < adIds.length; i++) {
            addAdTo(to, treeId, adIds[i]);
        }
    }

    function addAdMint(address to, string treeId, bytes9 adId) public onlyOwner {
        require(ownerOf(treeId) == to);
        _adToken.keyMintAdd(to, treeId, adId);
        addAdTo(to, treeId, adId);
    }
    
    function addAdsMint(address to, string treeId, bytes9[] adIds) public onlyOwner {
        require(ownerOf(treeId) == to);
        _adToken.keyMintAddMultiple(to, treeId, adIds);
        for (uint i = 0; i < adIds.length; i++) {
            addAdTo(to, treeId, adIds[i]);
        }
    }

    function transferAd(address from, address to, string treeId, bytes9 adId) public {
        require(ownerOf(treeId) == from);
        removeAdTo(from, treeId, adId);
        _adToken.transferAd(from, to, adId);
    }
    
    function transferAds(address from, address to, string treeId, bytes9[] adIds) public {
        require(ownerOf(treeId) == from);
        for (uint i = 0; i < adIds.length; i++) {
            removeAdTo(from, treeId, adIds[i]);
        }
        _adToken.transferAds(from, to, adIds);
    }

    function addDominantGene(address to, string treeId, uint256 geneId) public onlyOwner {
        require(ownerOf(treeId) == to);
        _dgToken.addGene(to, treeId, geneId);
        addDominantGeneTo(to, treeId, geneId);
    }
    
    function addDominantGenes(address to, string treeId, uint256[] geneIds) public onlyOwner {
        require(ownerOf(treeId) == to);
        _dgToken.addGenes(to, treeId, geneIds);
        for (uint i = 0; i < geneIds.length; i++) {
            addDominantGeneTo(to, treeId, geneIds[i]);
        }
    }

    function addDominantGeneMint(address to, string treeId, uint256 geneId) public onlyOwner {
        require(ownerOf(treeId) == to);
        _dgToken.keyMint(to, treeId, geneId);
        addDominantGeneTo(to, treeId, geneId);
    }
    
    function addDominantGenesMint(address to, string treeId, uint256[] geneIds) public onlyOwner {
        require(ownerOf(treeId) == to);
        _dgToken.keyMintMultiple(to, treeId, geneIds);
        for (uint i = 0; i < geneIds.length; i++) {
            addDominantGeneTo(to, treeId, geneIds[i]);
        }
    }

    function transferDominantGene(address from, address to, string treeId, uint256 geneId) public {
        require(ownerOf(treeId) == from);
        removeDominantGeneTo(from, treeId, geneId);
        _dgToken.transferGene(from, to, geneId);
    }
    
    function transferDominantGenes(address from, address to, string treeId, uint256[] geneIds) public {
        require(ownerOf(treeId) == from);
        for (uint i = 0; i < geneIds.length; i++) {
            removeDominantGeneTo(from, treeId, geneIds[i]);
        }
        _dgToken.transferGenes(from, to, geneIds);
    }

    function addRecessiveGene(address to, string treeId, uint256 geneId) public onlyOwner {
        require(ownerOf(treeId) == to);
        _rgToken.addGene(to, treeId, geneId);
        addRecessiveGeneTo(to, treeId, geneId);
    }
    
    function addRecessiveGenes(address to, string treeId, uint256[] geneIds) public onlyOwner {
        require(ownerOf(treeId) == to);
        _rgToken.addGenes(to, treeId, geneIds);
        for (uint i = 0; i < geneIds.length; i++) {
            addRecessiveGeneTo(to, treeId, geneIds[i]);
        }
    }

    function addRecessiveGeneMint(address to, string treeId, uint256 geneId) public onlyOwner {
        require(ownerOf(treeId) == to);
        _rgToken.keyMint(to, treeId, geneId);
        addRecessiveGeneTo(to, treeId, geneId);
    }
    
    function addRecessiveGenesMint(address to, string treeId, uint256[] geneIds) public onlyOwner {
        require(ownerOf(treeId) == to);
        _rgToken.keyMintMultiple(to, treeId, geneIds);
        for (uint i = 0; i < geneIds.length; i++) {
            addRecessiveGeneTo(to, treeId, geneIds[i]);
        }
    }
    
    function transferRecessiveGene(address from, address to, string treeId, uint256 geneId) public {
        require(ownerOf(treeId) == from);
        removeRecessiveGeneTo(from, treeId, geneId);
        _rgToken.transferGene(from, to, geneId);
    }
    
    function transferRecessiveGenes(address from, address to, string treeId, uint256[] geneIds) public {
        require(ownerOf(treeId) == from);
        for (uint i = 0; i < geneIds.length; i++) {
            removeRecessiveGeneTo(from, treeId, geneIds[i]);
        }
        _rgToken.transferGenes(from, to, geneIds);
    }
    
    function transferTree(address from, address to, string treeId) public {
        require(ownerOf(treeId) == from);
        bytes9[] memory adIds = ownedAds(treeId);
        for (uint i = 0; i < adIds.length; i++) {
            _adOwner[adIds[i]] = to;
        }
        _adToken.transferFroms(from, to, adIds);
        
        uint256[] memory dominantGeneIds = ownedDominantGenes(treeId);
        for (uint j = 0; j < dominantGeneIds.length; j++) {
            _dominantGeneOwner[dominantGeneIds[j]] = to;
        }
        _dgToken.transferFroms(from, to, dominantGeneIds);
        
        uint256[] memory recessiveGeneIds = ownedRecessiveGenes(treeId);
        for (uint k = 0; k < recessiveGeneIds.length; k++) {
            _recessiveGeneOwner[recessiveGeneIds[k]] = to;
        }
        _rgToken.transferFroms(from, to, recessiveGeneIds);
        
        transferFrom(from, to, treeId);
    }
}

// File: contracts/key/BBToken.sol

pragma solidity ^0.4.23;


contract BBToken is BBTokenImpl {
    using SafeMath for uint256;

    string tokenURI;

    event KeyMint(address _to, string tokenId);
    event KeyExchange(address _to, string tokenId);

    constructor ()
        ERC721Mintable()
        ERC721Full("BBToken", "BB") public {

        tokenURI = "";
    }


    function() public payable {
        revert();
    }

    function init(
        address adToken, 
        address dominantGeneToken,
        address recessiveGeneToken) public onlyOwner {
        
        _adToken = ADToken(adToken);
        _dgToken = DGToken(dominantGeneToken);
        _rgToken = RGToken(recessiveGeneToken);
    }

    function keyMint(
        address to, 
        string treeId) public onlyOwner {

        mintUniqueTokenTo(to, treeId, tokenURI);
        emit KeyMint(to, treeId);
    }
    
    /*function keyMintMultiple(
        address to,
        string[] memory treeIds) public onlyOwner {

        for (uint i = 0; i < treeIds.length; i++) {
            keyMint(to, treeIds[i]);
        }
    }*/


    function keyExchange(
        string treeId) public {

        burn(treeId);
        emit KeyExchange(msg.sender, treeId);
    }


    /*function keyExchangeMultiple(
        string[] memory treeIds) public {

        for (uint i = 0; i < treeIds.length; i++) {
            keyExchange(treeIds[i]);
        }
    }*/
}
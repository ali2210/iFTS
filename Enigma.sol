// SPDX-License-Identifier: MIT
pragma solidity  >=0.4.16 <0.9.0;


// Enigma contract is a specailize contract that create nft (non -fugible token) that store in ipfs network. 
// Make sure contract value  will be 20.

contract iFts{

    // contract params 

    // IPNS_LINK "is a storage location". Our fts (Fungible Tokens) are store in IPFS. Data store in IPFS allow to shared across peers on the network. This is a private network. Through some advance functions all FTS are available over public network.
    // These FTS are purchasable through iFTS contract. 
    string constant IPNS_LINK = "https://ipfs.io/ipns/k51qzi5uqu5djjs32dgcnh7ipz41i3ajzkyuf21hu90hdx8qcmiooeh3locn60";

    // Categories FTS 
    enum Collectibles_Items {ENIGMA_DIR, DAVID, SEVEN_DWARFS, WISDOMENIGMA_LOGO, WIZDWARFS_GENOME_EXTRACTOR, NONE}


    // User choices [0-5];
    int256 USER_CHOICES;


    // active_bit (Auction value);
    uint256 active_bit;


    // Public link of a purchase item
    string link;

    // minter wallet Address;
    address to_contract_Address = 0x081499De033920628e69D7d7630B66D4F7717912;


    // private mapping functiosn
    mapping (Collectibles_Items => int256) private  list;

    mapping (address => uint) private balance; 

    // Error state during execution.
    error Unexpected_State(string state);

    error Contract_Drop(string state, uint dump);


    // Sent event
    event Sent(address from, address to, uint amount);


    // contructor takes two arguments choice and bid.
    constructor (int256 choice, int256 bidder){

        if (USER_CHOICES >= 0 && USER_CHOICES < 5 && bidder > 0 && bidder < 100){

            USER_CHOICES = choice;
            active_bit = uint256(bidder);
            

        }else{

            revert Unexpected_State("Unexcepted State reported");
        }


        
        
    }

    //get choice return integer 256 bit long 
    function get_choice() public view returns (int256){
        
        return USER_CHOICES;
    }

    // mapper function which take a single argument collectibles_enum as parameter and return integer 256 bit long.
    // There may be possible that user throw wrong value then contract will throw errors. 
    function MapCollectToInteger(Collectibles_Items collect) private view returns (int256){

        if (collect == Collectibles_Items.NONE){

            revert Unexpected_State("Unexcepted State reported");
        }

        return list[collect];
    }


    // user will purchase items through this function. This function return flag and memory of a contract. Further read about memory in solidity.  
    // There may be possible that user have insufficent balance then contract will terminate.
    function purchase_item() public view returns (bool, string memory)  {

        bool check_balance;
        if (get_choice() == 0){

            require(MapCollectToInteger(Collectibles_Items.ENIGMA_DIR) != -1);
            check_balance = (get_balance() - active_bit) > 0 ? true : false;

            if (!check_balance){

                revert Unexpected_State("Low balance reported");
            }

            return (true, IPNS_LINK) ;
        }


        if (get_choice() == 1){

            require(MapCollectToInteger(Collectibles_Items.DAVID) != -1);
            check_balance = (get_balance() - active_bit) > 0 ? true : false;
            
            if (!check_balance){

                revert Unexpected_State("Low balance reported");
            }

            return (true, string.concat(IPNS_LINK,"david_nft.png"));
        }

        if (get_choice() == 2){

            require(MapCollectToInteger(Collectibles_Items.SEVEN_DWARFS) != -1);
            check_balance = (get_balance() - active_bit) > 0 ? true : false;
            
            if (!check_balance){

                revert Unexpected_State("Low balance reported");
            }

            return (true, string.concat(IPNS_LINK,"Seven_dwarfs_nft.png"));
        }

        if (get_choice() == 3){

            require(MapCollectToInteger(Collectibles_Items.WISDOMENIGMA_LOGO) != -1);
            check_balance = (get_balance() - active_bit) > 0 ? true : false;
            
            if (!check_balance){

                revert Unexpected_State("Low balance reported");
            }

            return (true, string.concat(IPNS_LINK,"wisdomenigma_logo.jpg"));
        }

        if (get_choice() == 4){

            require(MapCollectToInteger(Collectibles_Items.WIZDWARFS_GENOME_EXTRACTOR) != -1);
            check_balance = (get_balance() - active_bit) > 0 ? true : false;
            
            if (!check_balance){

                revert Unexpected_State("Low balance reported");
            }

            return (true, string.concat(IPNS_LINK,"wizdwarfs_genetic_file_uploader.png"));
        }

        return (false, "");
    } 


    // This function return bid value.
    function get_bid() public view returns (uint256){

        return active_bit;
    }

    // This function return user balance 
    function get_balance() public view returns(uint256){

        return balance[msg.sender];
    }

    // deposite is a function ... There may cause event that purchaser will not purchase any item before deposite . 
    function deposite() public {

        bool exe_op;
        

        (exe_op, link) = purchase_item();
        
        if (!exe_op){

            revert Contract_Drop("In sufficent balance report by virtual machine during transaction, hence we drop this contract...", 0x000);
            
        }
        
        emit Sent(msg.sender, to_contract_Address, active_bit);
    }

    // this function return purchase item as link. User will open in your browser and view that.
    function get_link() public view  returns (string memory){

        return link;
    }
}

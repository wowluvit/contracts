
a solidity ^0.8.0; solidity ^0.8.0;

/**
 * @title WowLuvIt
 * @dev WowLuvIt;   WARNING: this contract is too big and needs to be split up.
 */
contract WowLuvIt {

    address private owner;
    string public appName = "WowLuvIt";
    string public appNameLC = "wowluvit"; // lowercase

    string CelebrityCurators = "{'Benson', 'David', 'V', 'Tara', 'Ragil'}";

    string StandardTopics = "{'Animals', 'Cars', 'Travel', 'Sports', 'Web3'}";

       
    // modifier to check if caller is owner
    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    struct User {
        address accountAddress;
        string userName; 
        string email; 
        address []followList;
        address []followersList;
        address []blockList;
    } 

    struct Settings {
        address accountAddress;
        string defaultTopic;  
    }

    struct Profile {
        bool twoFactorSet;
    }

    struct Topic {
        string name; 
        string description; 
    }

    struct Group {
        uint id;
        address owner;
        string name; 
        string description;
		address  []memberList;
        address  []allowList;
		address  []blockList;
    }

    struct UserPosts {
                uint id;
                uint cardId; // belongs to which card.
				address owner;
				uint position;
				uint subThreadPosition;
				address []replyAllowList;
				address []blockList;
				string text;
                uint reactions;  // likes, wows etc.               
    }

    struct Card {
                uint id;
                uint streamId;
				address owner;
                bool foreignCard; // Shared onto this stream.
                bool shareableCard; // Can be shared onto other stream?
				uint dateTimeValue;
                string topComment;
                string imageLine;
                string bottomComment;
				address []AllowList;
				address []BlockList;
                address []ShareList;
				//UserPosts []userPosts;
    }

    struct Curator {
        uint id;     
        User user; 
        string description; 
        User []followersList;
    }

    struct CuratorStream {
        Curator curatorId;
        string name;
        string description;
        uint counter;
		address  []allowList;
		address  []blockList;
		Card  []userCards;
    }

    struct UserStream {
        uint id;
        address owner;
        string name;
        string description;
        uint counter;
		address  []allowList;
		address  []blockList;
		//Card  []userCards;
    }

    struct GroupStream {
        uint id;
        uint groupId;
        address owner;
        string name;
        string description;
        uint counter;
		address  []allowList;
		address  []blockList;
		//Card []userCards;
    }

    struct PayWall {
        uint id;
        address owner;
        string name;
        string description;
        uint entryFee;
		address  []allowList;
		address  []blockList;
		UserStream userStream;
    }

    struct Wallet {
        uint id;
        address owner;
        string name;
        string description;
        uint balance;
    }

    mapping(address => User) public usersList;
    mapping(address => Profile) public profilesList;
    mapping(address => Settings) public userSettings;
    mapping(address => Topic) public topics;
    mapping(address => Curator) public curators;
    mapping(address => Group) public groupList;
    mapping(address => UserStream) public home;
    mapping(address => UserStream) public animals;
    mapping(address => UserStream) public cars;
    mapping(address => UserStream) public travel;
    mapping(address => UserStream) public sports;
    mapping(address => UserStream) public web3;
    Card [100]homeCard;
    Card [100]animalsCard;
    Card [100]carsCard;
    Card [100]travelCard;
    Card [100]sportsCard;
    Card [100]web3Card;
    mapping(address => CuratorStream) public curatorStream;
    mapping(address => GroupStream) public groupStream;
    mapping(address => PayWall) public payWall;
    mapping(address => Wallet) public wallet;


    constructor() {
        owner = msg.sender; // 'msg.sender' is the contract deployer for a constructor
    }

    function getCelebrityCurators() external view returns (string memory) {
        return CelebrityCurators;
    }

    function getStandardTopics() external view returns (string memory) {
        return StandardTopics;
    }

    function addUser(string memory userName, string memory emailVal) public {
        usersList[msg.sender] = User(msg.sender, userName, emailVal, new address[](20), new address[](20), new address[](20)); 
        profilesList[msg.sender] = Profile(false);
        userSettings[msg.sender] = Settings(msg.sender, "HOME");
        wallet[msg.sender] = Wallet(block.timestamp, msg.sender, "mywallet", "WowLuvIt wallet", 0);
        home[msg.sender] = UserStream(block.timestamp, msg.sender, "home", "HomePage", 0, new address[](20), new address[](20));
        animals[msg.sender] = UserStream(block.timestamp, msg.sender, "Animals", "About Animals", 0, new address[](20), new address[](20));
        cars[msg.sender] = UserStream(block.timestamp, msg.sender, "Cars", "About Cars", 0, new address[](20), new address[](20));
        travel[msg.sender] = UserStream(block.timestamp, msg.sender, "Travel", "About Travel", 0, new address[](20), new address[](20));
        sports[msg.sender] = UserStream(block.timestamp, msg.sender, "Sports", "About Sports", 0, new address[](20), new address[](20)
        );
        web3[msg.sender] = UserStream(block.timestamp, msg.sender, "Web3", "About Web3", 0, new address[](20), new address[](20));
    }
 
    function addGroup(string memory groupName, string memory description)  public {
        // Note: groupList[msg.sender].counter++; 
        groupStream[msg.sender] = GroupStream(block.timestamp, block.timestamp, msg.sender, groupName, description, 0, new address[](20), new address[](20)); 
}


    function addCard(uint id, uint streamId, string memory topic, bool foreignCard, bool shareableCard, uint dateTimeValue, string  memory topComment, string  memory imageLine, string  memory bottomComment)  public {
        if (keccak256(abi.encodePacked('Animals')) == keccak256(abi.encodePacked(topic))) {
            animalsCard[animals[msg.sender].counter++] = Card(id, streamId, msg.sender, foreignCard, shareableCard, dateTimeValue, topComment, imageLine, bottomComment, new address[](20), new address[](20), new address[](20));
        } else if (keccak256(abi.encodePacked('Cars')) == keccak256(abi.encodePacked(topic))) {
            carsCard[cars[msg.sender].counter++] = Card(id, streamId, msg.sender, foreignCard, shareableCard, dateTimeValue, topComment, imageLine, bottomComment, new address[](20), new address[](20), new address[](20));
        } 
        else if (keccak256(abi.encodePacked('Travel')) == keccak256(abi.encodePacked(topic))) {
            travelCard[travel[msg.sender].counter++] = Card(id, streamId, msg.sender, foreignCard, shareableCard, dateTimeValue, topComment, imageLine, bottomComment, new address[](20), new address[](20), new address[](20));
        } else if (keccak256(abi.encodePacked('Sports')) == keccak256(abi.encodePacked(topic))) {
            sportsCard[sports[msg.sender].counter++] = Card(id, streamId, msg.sender, foreignCard, shareableCard, dateTimeValue, topComment, imageLine, bottomComment, new address[](20), new address[](20), new address[](20));
        } else if (keccak256(abi.encodePacked('Web3')) == keccak256(abi.encodePacked(topic))) {
            web3Card[cars[msg.sender].counter++] = Card(id, streamId, msg.sender, foreignCard, shareableCard, dateTimeValue, topComment, imageLine, bottomComment, new address[](20), new address[](20), new address[](20));
        } else
            homeCard[home[msg.sender].counter++] = Card(id, streamId, msg.sender, foreignCard, shareableCard, dateTimeValue, topComment, imageLine, bottomComment, new address[](20), new address[](20), new address[](20));
}

}


/**
 * @title WowLuvIt
 * @dev WowLuvIt. 
 */
contract WowLuvIt {

    address private owner;
    string public appName = "WowLuvIt";
    string public appNameLC = "wowluvit"; // lowercase

    string CelebrityCurators = "{'Benson', 'David', 'V', 'Tara', 'Ragil'}";

    string StandardTopics = "{'Animals', 'Cars', 'Travel', 'Sports', 'Web3'}";

       
    // modifier to check if caller is owner
    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    struct User {
        address accountAddress;
        string userName; 
        string email; 
        address []followList;
        address []followersList;
        address []blockList;
    } 

    struct Settings {
        address accountAddress;
        string defaultTopic;  
    }

    struct Profile {
        bool twoFactorSet;
    }

    struct Topic {
        string name; 
        string description; 
    }

    struct Group {
        uint id;
        address owner;
        string name; 
        string description;
		address  []memberList;
        address  []allowList;
		address  []blockList;
    }


    struct Comment {
                uint id;
                string text;
    }

    struct UserPosts {
                uint id;
                uint cardId; // belongs to which card.
				address owner;
				uint position;
				uint subThreadPosition;
				address []replyAllowList;
				address []blockList;
				Comment userComment;
                uint reactions;  // likes, wows etc.               

    }

    struct Card {
                uint id;
                uint streamId;
				address owner;
                bool foreignCard; // Shared onto this stream.
                bool shareableCard; // Can be shared onto other stream?
				uint dateTimeValue;
                string topComment;
                string imageLine;
                string bottomComment;
				address []AllowList;
				address []BlockList;
                address []ShareList;
				//UserPosts []userPosts;
    }

    struct Curator {
        uint id;     
        User user; 
        string description; 
        User []followersList;
    }

    struct CuratorStream {
        Curator curatorId;
        string name;
        string description;
		address  []allowList;
		address  []blockList;
		Card  []userCards;
    }

    struct UserStream {
        uint id;
        address owner;
        string name;
        string description;
		address  []allowList;
		address  []blockList;
		//Card  []userCards;
    }

    struct GroupStream {
        uint id;
        Group groupId;
        address owner;
        string name;
        string description;
		address  []allowList;
		address  []blockList;
		Card  []userCards;
    }

    struct PayWall {
        uint id;
        address owner;
        string name;
        string description;
        uint entryFee;
		address  []allowList;
		address  []blockList;
		UserStream userStream;
    }

    struct Wallet {
        uint id;
        address owner;
        string name;
        string description;
        uint balance;
    }

    mapping(address => User) public usersList;
    mapping(address => Profile) public profilesList;
    mapping(address => Settings) public userSettings;
    mapping(address => Topic) public topics;
    mapping(address => Curator) public curators;
    mapping(address => Group) public groupList;
    mapping(address => UserStream) public animals;
    mapping(address => UserStream) public cars;
    mapping(address => UserStream) public travel;
    mapping(address => UserStream) public sports;
    mapping(address => UserStream) public Web3;
    mapping(address => CuratorStream) public curatorStream;
    mapping(address => GroupStream) public groupStream;
    mapping(address => PayWall) public payWall;
    mapping(address => Wallet) public wallet;


    constructor() {
        owner = msg.sender; // 'msg.sender' is the contract deployer for a constructor
    }

    function getCelebrityCurators() external view returns (string memory) {
        return CelebrityCurators;
    }

    function getStandardTopics() external view returns (string memory) {
        return StandardTopics;
    }

    function addUser(string memory userName, string memory emailVal) public {
        usersList[msg.sender] = User(msg.sender, userName, emailVal, new address[](20), new address[](20), new address[](20)); 
        profilesList[msg.sender] = Profile(false);
        userSettings[msg.sender] = Settings(msg.sender, "HOME");
        wallet[msg.sender] = Wallet(block.timestamp, msg.sender, "mywallet", "WowLuvIt wallet", 0);
        animals[msg.sender] = UserStream(block.timestamp, msg.sender, "Animals", "About Animals", new address[](20), new address[](20));
        cars[msg.sender] = UserStream(block.timestamp, msg.sender, "Cars", "About Cars", new address[](20), new address[](20));
        travel[msg.sender] = UserStream(block.timestamp, msg.sender, "Travel", "About Travel", new address[](20), new address[](20));
        sports[msg.sender] = UserStream(block.timestamp, msg.sender, "Sports", "About Sports", new address[](20), new address[](20)
        );
        Web3[msg.sender] = UserStream(block.timestamp, msg.sender, "Web3", "About Web3", new address[](20), new address[](20));
    }
 
    function addGroup(uint id, string memory groupName, string memory description)  public {
        groupList[msg.sender] = Group(id, msg.sender, groupName, description, new address[](20), new address[](20), new address[](20)); 
}

    function addCard(uint id, uint streamId, bool foreignCard, bool shareableCard, uint dateTimeValue, string topComment, string imageLine, string bottomComment, , new address[](20), new address[](20), new address[](20))  public {
        groupList[msg.sender] = Group(id, msg.sender, groupName, description, new address[](20), new address[](20), new address[](20)); 
}
}

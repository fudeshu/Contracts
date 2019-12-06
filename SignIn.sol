pragma solidity ^0.4.23;


interface ITRC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    function transfer(address to, uint value) external returns (bool);

    function approve(address spender, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

    function transferTo(address to, uint value) external;

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Ownable {

    // public variables
    address public owner;

    // internal variables

    // events
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // public functions
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // internal functions
}
    
contract Pausable is Ownable {
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state. Assigns the Pauser role
     * to the deployer.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

library DateTime {
        /*
         *  Date and Time utilities for ethereum contracts
         *
         */
        struct _DateTime {
                uint16 year;
                uint8 month;
                uint8 day;
                uint8 hour;
                uint8 minute;
                uint8 second;
                uint8 weekday;
        }

        uint constant DAY_IN_SECONDS = 86400;
        uint constant YEAR_IN_SECONDS = 31536000;
        uint constant LEAP_YEAR_IN_SECONDS = 31622400;

        uint constant HOUR_IN_SECONDS = 3600;
        uint constant MINUTE_IN_SECONDS = 60;

        uint16 constant ORIGIN_YEAR = 1970;

        function isLeapYear(uint16 year) public pure returns (bool) {
                if (year % 4 != 0) {
                        return false;
                }
                if (year % 100 != 0) {
                        return true;
                }
                if (year % 400 != 0) {
                        return false;
                }
                return true;
        }

        function leapYearsBefore(uint year) public pure returns (uint) {
                year -= 1;
                return year / 4 - year / 100 + year / 400;
        }

        function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                        return 31;
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11) {
                        return 30;
                }
                else if (isLeapYear(year)) {
                        return 29;
                }
                else {
                        return 28;
                }
        }

        function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
                uint secondsAccountedFor = 0;
                uint buf;
                uint8 i;

                // Year
                dt.year = getYear(timestamp);
                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

                // Month
                uint secondsInMonth;
                for (i = 1; i <= 12; i++) {
                        secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
                        if (secondsInMonth + secondsAccountedFor > timestamp) {
                                dt.month = i;
                                break;
                        }
                        secondsAccountedFor += secondsInMonth;
                }

                // Day
                for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.day = i;
                                break;
                        }
                        secondsAccountedFor += DAY_IN_SECONDS;
                }

                // Hour
                dt.hour = getHour(timestamp);

                // Minute
                dt.minute = getMinute(timestamp);

                // Second
                dt.second = getSecond(timestamp);

                // Day of week.
                dt.weekday = getWeekday(timestamp);
        }

        function getYear(uint timestamp) public pure returns (uint16) {
                uint secondsAccountedFor = 0;
                uint16 year;
                uint numLeapYears;

                // Year
                year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

                while (secondsAccountedFor > timestamp) {
                        if (isLeapYear(uint16(year - 1))) {
                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                secondsAccountedFor -= YEAR_IN_SECONDS;
                        }
                        year -= 1;
                }
                return year;
        }

        function getMonth(uint timestamp) public pure returns (uint8) {
                return parseTimestamp(timestamp).month;
        }

        function getDay(uint timestamp) public pure returns (uint8) {
                return parseTimestamp(timestamp).day;
        }

        function getHour(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / 60 / 60) % 24);
        }

        function getMinute(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / 60) % 60);
        }

        function getSecond(uint timestamp) public pure returns (uint8) {
                return uint8(timestamp % 60);
        }

        function getWeekday(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, 0, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, minute, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
                uint16 i;

                // Year
                for (i = ORIGIN_YEAR; i < year; i++) {
                        if (isLeapYear(i)) {
                                timestamp += LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                timestamp += YEAR_IN_SECONDS;
                        }
                }

                // Month
                uint8[12] memory monthDayCounts;
                monthDayCounts[0] = 31;
                if (isLeapYear(year)) {
                        monthDayCounts[1] = 29;
                }
                else {
                        monthDayCounts[1] = 28;
                }
                monthDayCounts[2] = 31;
                monthDayCounts[3] = 30;
                monthDayCounts[4] = 31;
                monthDayCounts[5] = 30;
                monthDayCounts[6] = 31;
                monthDayCounts[7] = 31;
                monthDayCounts[8] = 30;
                monthDayCounts[9] = 31;
                monthDayCounts[10] = 30;
                monthDayCounts[11] = 31;

                for (i = 1; i < month; i++) {
                        timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
                }

                // Day
                timestamp += DAY_IN_SECONDS * (day - 1);

                // Hour
                timestamp += HOUR_IN_SECONDS * (hour);

                // Minute
                timestamp += MINUTE_IN_SECONDS * (minute);

                // Second
                timestamp += second;

                return timestamp;
        }
        
        /**获取星期*/
        function getWeekday2(uint timestamp) public pure returns (uint) {
                uint weekday = getWeekday(timestamp + 8 * HOUR_IN_SECONDS);
                if (weekday == 0) {
                    weekday = 7;
                }
                return weekday;
        }
        
        /**第几周*/
        function getWeeks(uint timestamp) public pure returns (uint) {
            uint day = (timestamp + 8 * HOUR_IN_SECONDS) / DAY_IN_SECONDS;
            return (day + 3) / 7;
        }
        
        /**日期*/
        function getDate(uint timestamp) public pure returns (uint) {
                _DateTime memory dt = parseTimestamp(timestamp + 8 * HOUR_IN_SECONDS);
                /**防止溢出*/
                uint year = dt.year;
                uint month = dt.month;
                uint day = dt.day;
                return year*10000 + month*100 + day;
        }
}

contract SignIn is Pausable {
    using SafeMath for uint256;
    uint256 public constant weekLen = 7;
    /**签到数据*/
    mapping(address => uint256[weekLen]) public signs;
    /**上次签到时间*/
    mapping(address => uint256) public lastSign;
    /**ff小数位*/
    uint256 public constant decimal = 6;
    /**ff地址*/
    ITRC20 public token = ITRC20(0x41FC371E5CB62C1C09431278E36004CBDF7772B03C);
    /**奖励*/
    uint256[8] public rewards = [10, 10, 20, 20, 30, 30, 40, 100];
    
    event Sign(address indexed addr, uint256 weekday, uint256 amount1, uint256 amount2);
    
    constructor() public {
    }
    
    /**设置ff地址*/
    function setToken(address ff) public onlyOwner {
        require(ff != address(0));
        token = ITRC20(ff);
    }
    
    /**设置奖励*/
    function setReward(uint256 index, uint256 amount) public onlyOwner {
        require(index >= 0 && index < rewards.length);
        rewards[index] = amount;
    }
    
    /**设置奖励*/
    function setRewards(uint256[] amounts) public onlyOwner {
        require(amounts.length == rewards.length);
        for (uint256 i = 0; i < rewards.length; i++) {
            rewards[i] = amounts[i];
        }
    }
    
    /**累计签到天数*/
    function getTotalSignDay() internal view returns(uint256) {
        uint256 day = 0;
        uint256[weekLen] storage signTimes = signs[msg.sender];
        uint256 weekday = DateTime.getWeekday2(now);
        for (uint256 i = 0; i < weekday; i++) {
            if (signTimes[i] > 0) {
                day = day.add(1);
            }
        }
        return day;
    }
    
    /**连续签到天数*/
    function getContinueSignDay() internal view returns(uint256) {
        uint256 day = 0;
        uint256[weekLen] storage signTimes = signs[msg.sender];
        uint256 weekday = DateTime.getWeekday2(now);
        for (uint256 i = weekday.sub(1); i >= 0; i--) {
            if (signTimes[i] == 0 && i != weekday.sub(1)) {
                break;
            }
            if (signTimes[i] > 0) {
                day = day.add(1);
            }
            if (i == 0) {
                break;
            }
        }
        return day;
    }
    
    /**签到数据*/
    function getSignData() public view returns(uint256[8], uint256[weekLen], uint256, uint256) {
        if (DateTime.getWeeks(lastSign[msg.sender]) != DateTime.getWeeks(now)) {
            return (rewards, [uint256(0), 0, 0, 0, 0, 0, 0], 0, 0);
        }
        return (rewards, signs[msg.sender], getTotalSignDay(), getContinueSignDay());
    }
    
    /**签到*/
    function sign() public whenNotPaused returns(uint256, uint256) {
        uint256[weekLen] storage signTimes = signs[msg.sender];
        /**不同周重置*/
        if (lastSign[msg.sender] > 0 && DateTime.getWeeks(lastSign[msg.sender]) != DateTime.getWeeks(now)) {
            for (uint256 i = 0; i < signTimes.length; i++) {
                if (signTimes[i] != 0) {
                    signTimes[i] = 0;
                }
            }
        }
        uint256 weekday = DateTime.getWeekday2(now);
        /**已签到*/
        if (signTimes[weekday.sub(1)] > 0) {
            return (1, 0);
        }
        uint256 amount1 = rewards[weekday.sub(1)].mul(10 ** decimal);
        uint256 amount2 = 0;
        if (getContinueSignDay() == 6) {
            amount2 = rewards[7].mul(10 ** decimal);
        }
        /**余额不足*/
        if (token.balanceOf(this) < amount1.add(amount2)) {
            return (2, 0);
        }
        signTimes[weekday.sub(1)] = now;
        lastSign[msg.sender] = now;
        token.transfer(msg.sender, amount1);
        if (getContinueSignDay() == 7) {
            amount2 = rewards[7].mul(10 ** decimal);
            token.transfer(msg.sender, amount2);
        }
        emit Sign(msg.sender, weekday, amount1, amount2);
        return (0, amount1.add(amount2));
    }
    
    function() public payable {
        revert();
    }
    
    function balance() public view returns(uint256) {
        return token.balanceOf(this);
    }
    
    function withdraw(address addr, uint256 amount) public onlyOwner {
        require(addr != address(0) && token.balanceOf(this) >= amount);
        token.transfer(addr, amount);
    }
}

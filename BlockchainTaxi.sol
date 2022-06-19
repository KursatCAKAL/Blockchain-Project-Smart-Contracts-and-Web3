// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;
//Author: Kursat Cakal
//Details: README.md
//Result: All functions are tested again and again they are operating without problem. As it can be seen in demo link.
//Demo Video Link: https://youtu.be/As3RDadX2LM (it includes demonstration for both successful cases and expected error cases)
//UnixTimestamp : 1670099282 for (2022/12/03-23:28:02). It can be used during test or can be generated new one with the link that exist in README
//Please UNLOCK the specified comment line and comment versus lines to achieve quick results instead waiting for 30 days or 6 months or use demo video to see quick result.
contract BlockchainTaxi 
{
    uint8 recursiveInnerCallFlagCarExpense = 0; //recursive inner call flag for achieving authorized call from PayDividend to CarExpenses and GetSalary modifiers
    uint8 recursiveInnerCallFlagGetSalary  = 0; //recursive inner call flag for achieving authorized call from PayDividend to CarExpenses and GetSalary modifiers
    uint8 maximumParticipants = 9;
    uint8 fireDriverProposals = 0;
    uint8 leaveJob = 0;
    uint256 TimestampDriverSalary;
    uint256 TimestampHandler;
    uint256 TimestampPayDividend;
    uint256 TimestampCarExpense;
    uint256 public contractBalance;
    uint256 public purchasedCar;
    uint fixedExpenses        = 10 ether;
    uint participationFee     = 80 ether;
    uint feePrecision         = 0.1 ether;     //when you input 35 for pPrice,pSalary it will corresponds 3.5 ether 
    uint maxGasFee            = 3000000;

    address payable[] participantList;
    address payable public carDealer;

    mapping (address => bool) approvedDriverParticipants;
    mapping (address => bool) approvedCarParticipants;
    mapping (address => bool) approvedRepurchasecarParticipants;
    mapping (address => bool) fireProposalsParticipant;
    mapping (address => Participant) public participants;

    constructor() 
    {
        carDealer = payable(msg.sender);
        contractBalance = 0;
        TimestampHandler = block.timestamp;
        TimestampPayDividend = block.timestamp;
        TimestampCarExpense = block.timestamp;
    }

    ProposedCar proposedCar;
    ProposedCar proposedRepurchasecar;
    ProposedDriver proposedDriver;
    TaxiDriver public taxiDriver;

    struct Participant 
    {
        address payable participantAdress;
        uint localBalance;
    }
    
    struct TaxiDriver 
    {
        address payable accountAddress;
        uint salary;
        uint localBalance;
    }
    
    struct ProposedDriver 
    {
        TaxiDriver taxiDriver;
        uint8 approvalState;
    }

    struct ProposedCar 
    {
        uint256 carID;
        uint price;
        uint timeOffer; // use https://www.unixtimestamp.com/ to generate valid time
        uint8 approvalState;
    }

    modifier carDealerMode 
    {
        require(msg.sender == carDealer, "Authorization level is not enough for the operation. Car Dealer authorization is required. Please change <Account> address.");
        _;
    }
    
    modifier driverMode 
    {
        if(1 == recursiveInnerCallFlagGetSalary)
        {
            //this line let for calling CarExpenses inside PayDividend without authorization constations.
            require(1 == recursiveInnerCallFlagGetSalary);//If this line didn't add systems will not pay dividend to user due to modifier requirements arent met. Be careful!
            _;
        }
        else
        {
            require(msg.sender == taxiDriver.accountAddress, "Authorization level is not enough for the operation. Driver authorization is required. Please change <Account> address.");
            _;
        }
    }
    
    modifier participantMode 
    {
        if(1 == recursiveInnerCallFlagCarExpense)
        {
            //this line let for calling CarExpenses inside PayDividend without authorization constations.
            require(1 == recursiveInnerCallFlagCarExpense);//If this line didn't add systems will not pay dividend to user due to modifier requirements arent met. Be careful!
            _;
        }
        else
        {
            require(participants[msg.sender].participantAdress == msg.sender, "Authorization level is not enough for the operation. Participant authorization is required. Please change <Account> address.");
            _;
        }
    }
    
    function Join() external payable {
        require(participantList.length < maximumParticipants, 'Maximum 9 user can be participate to this contract.');
        require(participants[msg.sender].participantAdress != msg.sender, 'Same user can not be join to the contract again. Please Join as different Account.');
        require(msg.value == participationFee, 'Participation fee must be 80 ether. Please dont use Wei instead Ether. Check the input Value!');
        require(msg.sender !=taxiDriver.accountAddress,'Taxi Driver can not be also as a normal participant please select different Account.');
        require(msg.sender !=carDealer,'Car Dealer can not be also as a normal participant please select different Account.');
        contractBalance += participationFee;
        participants[payable(msg.sender)] = Participant({participantAdress: payable(msg.sender), localBalance: 1 ether}); 
        participantList.push(payable(msg.sender));
    }

    function CarProposeToBusiness(uint256 pCarID, uint pPrice, uint pTimeOffer) public carDealerMode 
    {
        if(pCarID == 0 || pPrice == 0 || pTimeOffer == 0)
        {
            revert("Please input valid car parameters to purchase car, except '0' !. You can use unixtimestamp.com to generate pTimeOffer");
        }
        proposedCar = ProposedCar({carID:pCarID,price:pPrice * feePrecision, timeOffer:pTimeOffer,approvalState:0 });
        for (uint i = 0; i < participantList.length; i++) 
        {
            approvedCarParticipants[participantList[i]] = false;
        }
    }
    
    function ApprovePurchaseCar() public participantMode 
    {
        require(approvedCarParticipants[msg.sender] == false, 'This participant already approved for this car.');
        require(msg.sender !=taxiDriver.accountAddress,'Taxi Driver can not be approve puchase operation please select different Account.');
        require(msg.sender !=carDealer,'Car Dealer can not be approve puchase operation please select different Account.');
        approvedCarParticipants[msg.sender] = true;
        proposedCar.approvalState++;
        if(proposedCar.approvalState > (participantList.length / 2))
        {
            PurchaseCar();//Car is purchased. No need for more purchase approvel.
        }
    }
    
    function PurchaseCar() public 
    {
        require(proposedCar.timeOffer > block.timestamp, 'Car can not purchase due to invalid time.');
        require(proposedCar.approvalState > (participantList.length / 2), 'Approvel is required more than half of participants.');
        require(proposedCar.price < contractBalance , 'Price of the Proposed Car cant be higher than contract balance.');
        if(purchasedCar != 0)
        {
            revert("There are already purchased car.");
        }
        purchasedCar = proposedCar.carID;
        contractBalance -= proposedCar.price;
        carDealer.transfer(proposedCar.price);
    }

    function RepurchaseCarPropose(uint256 pCarID, uint pPrice, uint pTimeOffer) public carDealerMode 
    {
        require(purchasedCar != 0, 'You are not able to repurchase car due to the fact that you do not have purchased one.');
        if(pCarID != purchasedCar)
        {
            revert("Please input valid car parameters to repurchase car, except '0' !. You can use unixtimestamp.com to generate pTimeOffer");
        }
        proposedRepurchasecar = ProposedCar({carID:pCarID,price:pPrice * feePrecision, timeOffer:pTimeOffer,approvalState:0});
        for (uint i = 0; i < participantList.length; i++) {
            approvedCarParticipants[participantList[i]] = false;
        }
    }

    function ApproveSellProposal() public participantMode 
    {
        require(purchasedCar != 0, 'You are not able to approve car sell due to the fact that you do not have purchased one.');
        require(approvedRepurchasecarParticipants[msg.sender] == false, 'This participant already approved for this car.');
        
        approvedRepurchasecarParticipants[msg.sender] = true;
        proposedRepurchasecar.approvalState++;
        if(proposedRepurchasecar.approvalState > (participantList.length / 2))
        {
            Repurchasecar(); //Car is purchased. No need for more repurchase sell approvel.
        }
    }

    function Repurchasecar() public  
    {
        require(purchasedCar != 0, 'You are not able to approve car sell due to the fact that you do not have purchased one.');
        require(proposedRepurchasecar.timeOffer > block.timestamp,'Car can not be sell due to valid time is expired.');
        require(proposedRepurchasecar.approvalState > (participantList.length / 2), 'Approvel is required more than half of participants.');
        contractBalance += proposedRepurchasecar.price;
        purchasedCar = 0;
    }

    function ProposeDriver(address payable pAccountAddress, uint pSalary) public 
    {
        require(pAccountAddress != payable(address(0)) && pSalary != 0, 'Please input valid localBalance address and salary!');
        proposedDriver = ProposedDriver({taxiDriver: TaxiDriver({accountAddress: pAccountAddress,salary: pSalary * feePrecision ,localBalance: 0}),approvalState: 0});
        for (uint i = 0; i < participantList.length; i++) 
        {
            approvedDriverParticipants[participantList[i]] = false;
        }
    }
    function ApproveDriver() public participantMode 
    {
        require(approvedDriverParticipants[msg.sender] == false, 'This participant already approved for this car.');
        require(proposedDriver.taxiDriver.accountAddress != address(0) && proposedDriver.taxiDriver.salary != 0, 'You are not able to approve drive due to no proposed driver is exist.');
        approvedDriverParticipants[msg.sender] = true;
        proposedDriver.approvalState++;
        if(proposedDriver.approvalState > (participantList.length / 2))
        {
            SetDriver();//Driver setted. No need for more driver approvel.
        }
    }

    function SetDriver() public 
    {
        if(taxiDriver.accountAddress != address(0) && taxiDriver.salary != 0)
            revert("There is a driver already setted.");
        if(proposedDriver.taxiDriver.accountAddress == address(0) && proposedDriver.taxiDriver.salary == 0 )
            revert("No proposed driver is exist to be set.");
        require(proposedDriver.approvalState > (participantList.length / 2), 'Approvel is required more than half of participants.');

        taxiDriver = proposedDriver.taxiDriver;
        TimestampDriverSalary = block.timestamp;

        proposedDriver.taxiDriver.accountAddress = payable(address(0));
        proposedDriver.taxiDriver.salary = 0;
        proposedDriver.taxiDriver.localBalance = 0;
        proposedDriver.approvalState = 0;
    }

    function ProposeFireDriver() public participantMode
    {
        require(fireProposalsParticipant[msg.sender] == false, 'This participant already approved for firing driving process.');
        require(taxiDriver.accountAddress != payable(address(0)), "There must be a driver to fire him/her.");
        fireProposalsParticipant[msg.sender] = true;
        fireDriverProposals++;
        if(fireDriverProposals > (participantList.length / 2))
        {
            FireDriver();//Driver fired. No need for more driver approvel.
        }
    }

    function FireDriver() public payable
    {
        require(taxiDriver.accountAddress != payable(address(0)), "There must be a driver to fire him/her.");
        if(1 == leaveJob)
        {
            leaveJob = 0; //clear leave flag for next operations
            taxiDriver.localBalance += taxiDriver.salary;
            contractBalance -= taxiDriver.salary;
            if(taxiDriver.localBalance > 0)
                taxiDriver.accountAddress.transfer(taxiDriver.localBalance);
            taxiDriver.accountAddress = payable(address(0));
            taxiDriver.localBalance = 0;
            taxiDriver.salary = 0;
        }
        else
        {
            require((fireDriverProposals > (participantList.length / 2)) , 'Fire proposal is required more than half of participants.'); //blocks direct call of FireDriver
            taxiDriver.localBalance += taxiDriver.salary;
            contractBalance -= taxiDriver.salary;
            if(taxiDriver.localBalance > 0)
                taxiDriver.accountAddress.transfer(taxiDriver.localBalance);
            taxiDriver.accountAddress = payable(address(0));
            taxiDriver.localBalance = 0;
            taxiDriver.salary = 0;
        }
        for (uint i = 0; i < participantList.length; i++)//to be able to hire driver and then fire again.
        {
            fireProposalsParticipant[msg.sender] = false;
        }
    }

    function LeaveJob() public driverMode 
    {
        leaveJob = 1; //permits direct call of FireDriver according to homework project scenario
        FireDriver();
    }

    function GetCharge() public payable 
    {
        if(block.timestamp > proposedCar.timeOffer )
            revert("Taxi service time expired.");

        if (proposedCar.carID == 0 && proposedCar.price == 0 || purchasedCar == 0)
            revert("No taxi is exist to serve. Please purchase a taxi.");
            
        if (taxiDriver.accountAddress == payable(address(0)))
            revert("No taxi driver is exist to server. Please hire a driver.");
    
        if (msg.value == 0)
            revert("Input fee is required!");

        if (msg.value > 0 ether && msg.value < 100 ether)//< payable(msg.sender).balance)
            contractBalance += msg.value;
        else
            revert("Please pay less Customer's fee. Balance is not enough to pay taxi service fee.");
    }

    function GetSalary() public driverMode 
    {
        //UNLOCK Comment to see consecutive quick payments
        //if( (taxiDriver.salary > 0 && taxiDriver.accountAddress != address(0)) && block.timestamp >= TimestampDriverSalary + 10 seconds)
        if( (taxiDriver.salary > 0 && taxiDriver.accountAddress != address(0)) && block.timestamp >= TimestampDriverSalary + 30 days) 
        {
            if(contractBalance - taxiDriver.salary > 0)
            {
                taxiDriver.localBalance += taxiDriver.salary;
                contractBalance -= taxiDriver.salary;
                taxiDriver.accountAddress.transfer(taxiDriver.localBalance);
                taxiDriver.localBalance = 0; // we should set zero for localBalance, because if driver call leaveJob he/she will get one more salary.
                TimestampDriverSalary = block.timestamp;
            }
            else
            {
                revert("Contract Balance can't pay driver's salary.");
            }
        }
        else
        {
            if(1 == recursiveInnerCallFlagGetSalary)
            {
                recursiveInnerCallFlagGetSalary = 0;
                //GetSalary can call by driver before the call of PayDividend. What if PayDividend call after GetSalary again? Multiple call can occure.
                //Passing case is required for PayDividend calls after GetSalary calls.
                //If this passing is not exist, system can't dividend because of rising revert errors.
            }
            else if(taxiDriver.salary == 0 && taxiDriver.accountAddress == address(0))
            {
                revert("There must be a Driver in the contract to get salary operation.");
            }
            //UNLOCK Comment to see consecutive quick payments
            //else if(block.timestamp < TimestampDriverSalary + 10 seconds)
            else if(block.timestamp < TimestampDriverSalary + 30 days)
            {
                revert("More than one payment is not permitted in 30 days.");
            }
        }
    }

    function CarExpenses() public participantMode 
    {
        //UNLOCK Comment to see consecutive quick payments
        //if(block.timestamp >= TimestampCarExpense + 10 seconds)
        if(block.timestamp >= TimestampCarExpense + 180 days)
        {
            TimestampCarExpense = block.timestamp;
            contractBalance -= fixedExpenses;
            carDealer.transfer(fixedExpenses);
        }
        else
        {
            if(1 == recursiveInnerCallFlagCarExpense)
            {
                recursiveInnerCallFlagCarExpense = 0;
                //CarExpense can call by participants before the call of PayDividend. What if PayDividend call after CapExpense again? Multiple call can occure.
                //Passing case is required for PayDividend calls after CarExpsense calls.
                //If this passing is not exist, system can't dividend because of rising revert error.
            }
            //UNLOCK Comment to see consecutive quick payments
            //else if(block.timestamp < TimestampCarExpense + 10 seconds)
            else if(block.timestamp < TimestampCarExpense + 180 days)
            {
                revert("6 months are required to realize Car Expenses operation. Timestamp can be manipulated in code-side for quick test as 10 seconds.");
            }
        }
    }

    function PayDividend() public participantMode 
    {
        //UNLOCK Comment to see consecutive quick payments
        //require(block.timestamp >= TimestampPayDividend + 10 seconds,'10 Seconds are required to realize Pay Dividend operation.'); 
        require(block.timestamp >= TimestampPayDividend + 180 days,'6 months are required to realize Pay Dividend operation. Timestamp can be manipulated in code-side for quick test as 10 seconds.');
        recursiveInnerCallFlagGetSalary  = 1;//let CarExpense function to call without authorization restriction
        recursiveInnerCallFlagCarExpense = 1;//let GetSalary function to call without authorization restriction

        CarExpenses();//consecutive calls are avoided between PayDividend and CarExpenses functions.
        GetSalary();//consecutive calls are avoided between PayDividend and CarExpenses functions.

        recursiveInnerCallFlagGetSalary  = 0;//Clear for not effecting other modifier actions. 
        recursiveInnerCallFlagCarExpense = 0;//Clear for not effecting other modifier actions. 
        uint profitThreshold = participationFee * participantList.length;
        require(contractBalance > profitThreshold, "Contract doesnt make profit yet. So, you cant pay dividend. Please wait for more customer.");
        uint totalProfit = contractBalance - profitThreshold;
        uint calculatedProfit = totalProfit / participantList.length;
        for (uint i = 0; i < participantList.length; i++) {
            participants[participantList[i]].localBalance += calculatedProfit;
            contractBalance -= calculatedProfit;
        }
        
        TimestampPayDividend = block.timestamp;
    }

    function GetDividend() public payable participantMode 
    {
        uint pLocalBalanceForParticipant = participants[msg.sender].localBalance;
        participants[msg.sender].localBalance = 0;
        payable(msg.sender).transfer(pLocalBalanceForParticipant);
    }
    receive()  external payable {revert ();}
    fallback() external payable {revert ();}
}
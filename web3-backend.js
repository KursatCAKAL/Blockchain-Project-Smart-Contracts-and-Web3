var defaultGasFee = 3000000; //128329 
var defaultInvestmentPerUser= 40000000000000000000; //minimal amount

try
{
    alert("Please be sure about three things:\n\n-Socket 8545 is ready to use!!!\n\n-ABI JSON Code is Configured\n\n-Contract Address is Configured !!!");
    
    // Initiate Gateway Object
    gatewayWeb3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));
    
    // Put Contract Address and ABI from Solidity. Please make sure to use JSON Minifier for readable code.
    var contractAddress = "0xE1C4E8e775a4935f6eADD0e92CfC1D11486e080b";
    var contractABI = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"eventType","type":"string"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"MaintenanceExpenseEvent","type":"event"},{"stateMutability":"nonpayable","type":"fallback"},{"inputs":[],"name":"approveDriver","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"approvePurchaseCar","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"approveSellProposal","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"carDealer","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"carExpenses","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_carID","type":"uint256"},{"internalType":"uint256","name":"_price","type":"uint256"},{"internalType":"uint256","name":"_offerValidTime","type":"uint256"}],"name":"carProposeToBusiness","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"contractBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"fireDriver","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getCharge","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"getDividend","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getParticipantCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"participantIndex","type":"uint256"}],"name":"getParticipantDetails","outputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"address payable","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getSalary","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"join","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"manager","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ownedCar","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"participantArray","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"participants","outputs":[{"internalType":"address payable","name":"participantAdress","type":"address"},{"internalType":"uint256","name":"account","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"payDividend","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_driverAdress","type":"address"},{"internalType":"uint256","name":"_salary","type":"uint256"}],"name":"proposeDriver","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"purchaseCar","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"releaseSalary","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"repurchaseCar","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_carID","type":"uint256"},{"internalType":"uint256","name":"_price","type":"uint256"},{"internalType":"uint256","name":"_offerValidTime","type":"uint256"}],"name":"repurchaseCarPropose","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address payable","name":"_carDealer","type":"address"}],"name":"setCarDealer","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"setDriver","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"taxiDriver","outputs":[{"internalType":"address payable","name":"driverAdress","type":"address"},{"internalType":"uint256","name":"salary","type":"uint256"},{"internalType":"uint256","name":"account","type":"uint256"}],"stateMutability":"view","type":"function"},{"stateMutability":"payable","type":"receive"}];

    // Call and Initiate Contract via Web3
    var solidityContractInstance = new gatewayWeb3.eth.Contract(
        contractABI,
        contractAddress
    );
    // Get Optional Logs
    console.log(solidityContractInstance);
    
    // Connection Status
    $('#resultTable').find('tbody').append('<tr class="textgreencolor offericon"><td>Web3 Integrated Successfully for your browser..</td></tr>');
}
catch
{
    $('#resultTable').find('tbody').append('<tr class="textredcolor offericon"><td>Web3 is not able to successfully integrate for your browser. Please check your Web3-Node Modules is exist in directory. Sure About Contract Address and ABI JSON Outputs</td></tr>');
}

$(document).ready(function(){
    //HEAD:gatewayWeb3.eth.getAccounts().then(function () {});
    gatewayWeb3.eth.getAccounts().then(function (users) {
        

    });
    //TAIL:gatewayWeb3.eth.getAccounts().then(function () {});
});
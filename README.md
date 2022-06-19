<p align="center"> <h1 align="center">  🎯 Blockchain Project - Smart Contracts with Solidity & Web3 🎯 </h1> </p>

<div align="center">

Project | Author |
:---: | :---: |
Web3 based Blockchain App | Kursat Cakal	
	
</div>

<div align="center">
	
Required Libraries, Tools and Systems | Version
------------ | -------------
Node | 9.7.1
Remix IDE | 1.3.3
Ganache CLI | 6.12.2
VS Code | 1.68.1
JQuery | 2.0.0
Bootstrap | 5.0.2
Electron | 17.4.7
Node.js | 16.13.0
Windows | 11 Pro

</div>

## 🚀 Guidelines - Section 1

<div align="center">
	
✨ Guideline Steps ✨
	
</div>


```
1-) Go : 
	https://nodejs.org/download/release/v9.7.1/
    Download :
	node-v9.7.1-x64.msi                                02-Mar-2018 02:32            16637952
	node-v9.7.1-x86.msi                                02-Mar-2018 02:07            15085568
2-) Install Remix IDE or Use It Online (it requires some configuration to access local)
3-) Run: npm install -g ganache-cli
Ganache CLI is the latest version of TestRPC: a fast and customizable blockchain emulator. It allows you to make calls to the blockchain without the overheads of running an actual Ethereum node.
4-) Open terminal
5-) Run: ganache-cli
6-) Run: cd Desktop
7-) Run: mkdir ProjectWorkspace
8-) Run: npm init
    Run: npm install ethereum/web3.js --save (it doesn't work)
    use it instead:
    ( Run: npm install web3 )
9-) Open ProjectWorkspace by RemixIDE in localhost Workspaces
10-) Compile .sol file.
11-) Select Environment as Web3 Provider
12-) Copy ABI from Compilation Details
13-) Paste it into https://www.webtoolkitonline.com/json-minifier.html
14-) Get minified inline/block form of ABI JSON codes
15-) Then deploy your contract and Copy Contract Address
16-) paste step 13 out and step 14 out to the html file web3 contract
var taxiBusiness = new web3.eth.Contract([....json....],"CONTRACT ADDRESS");
17-) Interact your Smart Contract with Web3 
18-) Happy End
```
	
## 🚀 Assumptions - Section 2
o-> Valid Time used as Unix Time Format. It can be generated from here : https://www.unixtimestamp.com/  <br/>
o-> If you want to see instant result without waiting 30 days, 180 days for payment progress, please UNCOMMENT 308, 338, 349, 366, 377 code lines and COMMENT 309, 339, 350, 367, 378 lines. It uses only 10 seconds threshold for operations.  <br/>
o-> Fee Precision for pPrice and pSalary is 0.1F to achieve more flexible payment for input parameters and to achieve fast input during tests.  <br/>
    For example: It will correnpond 3.5 if you input 35 in Deployed Contracts input area.  <br/>
o-> Participation Fee is 80 ether   <br/>
o-> Fixed Expense is 10 ether   <br/>
o-> Value unit should use as "Ether" not as "Wei" <br/>
o-> Price of the ProposedCar can't be higher than contract balance !! <br/>
o-> PayDividend cant be succesfull without the Contract doesnt make profit! <br/>
o-> GetSalary method can't call before propose a driver and taxi. <br/>
o-> Only one proposal can be set for car purchase at the same time. <br/>
o-> Car can't be sell if invalid pCarID parameter given as input. <br/>
o-> Purchased car can be sell more expensive than received price.  <br/>
o-> Only One Driver can be proposed. Driver Proposals not holding in any array to select between multiple proposal due to extra test inputs are required about which one to approve. <br/>

## 🚀 Helpful Resources - Section 3

1-)Error for transfer solution can be found here <br/>
-> https://codeforgeek.com/solve-transaction-error-in-solidity/ <br/>
2-)Modifiers <br/>
-> https://www.tutorialspoint.com/solidity/solidity_function_modifiers.htm <br/>
3-)Contract Pending <br/>
-> https://ethereum.stackexchange.com/questions/44076/remix-stuck-on-creation-of-contract-pending <br/>
-> https://ethereum.stackexchange.com/questions/30004/nothing-returned-and-transact-pending <br/>
4-)Error Handling <br/>
-> https://docs.soliditylang.org/en/v0.8.13/control-structures.html#error-handling-assert-require-revert-and-exceptions <br/>
5-)Solidity Time Units <br/>
-> https://docs.soliditylang.org/en/v0.8.13/units-and-global-variables.html <br/>
6-)Creating Unix Time <br/>
-> https://www.unixtimestamp.com/ <br/>

## ✨ Result
All functions are tested again and again they are operating without problem. As it can be seen in demo link. <br/>
## ✨ Demo Link
https://youtu.be/As3RDadX2LM (it includes demonstration for both successful cases and expected error cases) <br/>

pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

contract paymentwallet{
    address[] approvers;
    address payable beneficary;
    address payable owner;
    
    mapping(address => bool) isApprover;
    mapping(address => bool) approvedBy;
    
    uint approvalSum;
    uint reqApprovals;
    
    constructor(address payable _beneficary, address[] memory _approvers, uint _reqApprovals)public payable {
        require(_reqApprovals<=_approvers.length,"More Approvers Required");
        approvers = _approvers;
        beneficary =  _beneficary;
        reqApprovals = _reqApprovals;
        owner = msg.sender;
        
        for(uint i=0;i<approvers.length;i++){
            address approverAddress = approvers[i];
            isApprover[approverAddress]=true;
        }
    }
    function acceptTheTransaction() public payable{
        require(isApprover[msg.sender],"Not an approver");
        
        if(!approvedBy[msg.sender]){
            approvalSum++;
            approvedBy[msg.sender]=true;
        }else{
            revert("Already Approved");
        }
        if(approvalSum==reqApprovals){
            beneficary.transfer(address(this).balance);
            selfdestruct(owner);
        }
        
        
    }
    function rejectTheTransaction() public{
        require(isApprover[msg.sender],"Not an approver");
        
        selfdestruct(owner);
        
    }
    
    function getApprovers() public view returns(address[] memory){
        return approvers;
    }
    function getOwner() public view returns(address ){
        return owner;
    }
    function getBeneficiary() public view returns(address ){
        return beneficary;
    }
    
}
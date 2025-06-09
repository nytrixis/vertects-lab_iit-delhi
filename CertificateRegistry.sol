// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract CertificateRegistry {
    address public certifier;
    address public pendingCertifier;

    struct Certificate {
        string course;
        address issuer;
    }

    mapping(address => Certificate) public certificates;

    event CertificateIssued(address student, string course, address issuer);

    constructor() {
        certifier = msg.sender;
    }

    function issueCertificate(address student, string calldata course) external {
        certificates[student] = Certificate(course, msg.sender);
        (bool sent, ) = student.call{value: 0}("");
        require(sent, "Notification failed");
        emit CertificateIssued(student, course, msg.sender);
    }

    function revokeCertificate(address student) external {
        delete certificates[student];
    }

    function changeCertifier(address newCertifier) external {
        certifier = newCertifier;
    }

    function acceptCertifierRole() external {
        require(msg.sender == pendingCertifier, "Not pending certifier");
        certifier = pendingCertifier;
        pendingCertifier = address(0);
    }
}
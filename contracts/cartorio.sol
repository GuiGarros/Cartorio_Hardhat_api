// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Cartorio {
    address governo;
    mapping(uint => address) public indexPropriedadeDono;
    mapping(uint => address) public indexPropriedadeContrato;
    mapping(address => string) public indexSenhas;
    string testeString = "garros";


    constructor() {
        governo = (msg.sender);
    }

    function registraPropriedade(uint index, address dono) public payable{
        require(msg.sender == governo);
        indexPropriedadeDono[index] = dono; 
    }

    function registraSenha(string memory senha) public payable{
        indexSenhas[msg.sender] = senha;
    }

    function getSenha() public view returns (string memory) {
        return indexSenhas[msg.sender] ;
    }

    function getTesteString() public view returns(string memory) {
        return testeString;
    }
    
    
    function criaVenda(uint index) public payable {
        require(msg.sender == indexPropriedadeDono[index]);
        address novaVenda = address(new ContratoVenda(msg.sender));
        ContratoVenda teste = ContratoVenda(novaVenda);
        require (msg.sender == teste.getVendedor());
        indexPropriedadeContrato[index] = novaVenda;

    }

    // modifier soGoverno() {
    //     require(msg.sender == governo);
    //     _;
    // }
}

contract ContratoVenda {
    address payable public vendedor;
    address public comprador;
    uint public valor;

    constructor(address vendor) {
        vendedor = payable(vendor);
    }

    function setValor(uint preco) public payable{
        valor = preco*1000000000000000000;
    }

    function compradorAddress(address addressComprador) public payable{
       comprador = addressComprador;
    }

    function concluiCompra() public payable soComprador{
        require(msg.value >= valor );
        vendedor.transfer(address(this).balance);
    }

    modifier soComprador() {
        require(msg.sender == comprador);
        _;
    }

    modifier soVendedor()
    {
        require(msg.sender == vendedor);
        _;
    } 

    function getVendedor() public view returns (address){
        return vendedor;
    }

    function getValor() public view returns (uint){
        return valor;
    }
}
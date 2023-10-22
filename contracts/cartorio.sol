// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Cartorio {
    address governo;
    mapping(uint => address) public indexPropriedadeDono;
    mapping(uint => address) public indexPropriedadeContrato;
    mapping(address => string) public indexSenhas;

    constructor() {
        governo = (msg.sender);
    }

    function registraPropriedade(uint index, address dono) public {
        require(msg.sender == governo);
        indexPropriedadeDono[index] = dono; 
    }

    function registraSenha(string memory senha) public {
        indexSenhas[msg.sender] = senha;
    }

    function getSenha() public view returns (string memory) {
        return indexSenhas[msg.sender] ;
    }
    
    function criaVenda(uint index, uint preco, address payable comprador) public {
        require(msg.sender == indexPropriedadeDono[index]);
        require(indexPropriedadeContrato[index] == address(0));
        address novaVenda = address(new ContratoVenda(msg.sender, preco, comprador));
        ContratoVenda teste = ContratoVenda(novaVenda);
        require (msg.sender == teste.getVendedor());
        indexPropriedadeContrato[index] = novaVenda;

    }

    function existeVenda(uint index) public view returns (bool) {
        ContratoVenda contrato = ContratoVenda(indexPropriedadeContrato[index]);
        return contrato.getAtivo();
    } 

    function getVendaAddress(uint index) public view returns (address) {
        return indexPropriedadeContrato[index];
    }

    function finalizaVenda(uint index) public payable {
        ContratoVenda venda = (ContratoVenda(indexPropriedadeContrato[index]));
        address novoDono = venda.getComprador();
        indexPropriedadeDono[index] = novoDono;
        venda.desativaContrato();
        indexPropriedadeContrato[index] = address(0);
    }

    function cancelaCompra(uint index) public {
        ContratoVenda venda = (ContratoVenda(indexPropriedadeContrato[index]));
        venda.desativaContrato();
        indexPropriedadeContrato[index] = address(0);
    }

}

contract ContratoVenda {
    address payable public vendedor;
    address payable public comprador;
    uint public valor;
    bool ativo = true;
    bool pago = false;

    constructor(address vendor, uint preco, address payable addressComprador) {
        vendedor = payable(vendor);
        valor = preco;
        comprador = addressComprador;
    }

    function setValor(uint preco) public {
        valor = preco;
    }

    function compradorAddress(address payable addressComprador, uint preco) public contratoAtivo{
       comprador = addressComprador;
       valor = preco;
    }

    function finalizarVenda() public payable contratoAtivo {
        require(msg.value >= valor );
        vendedor.transfer(address(this).balance);
        pago = true;
    }

    function desativaContrato() public {
        ativo = false;
    }

    function getAtivo() public view returns (bool) {
        return ativo;
    }

    modifier soComprador() {
        require(msg.sender == comprador);
        _;
    }

    modifier contratoAtivo() {
        require(ativo);
        _;
    }

    modifier soVendedor()
    {
        require(msg.sender == vendedor);
        _;
    } 

    modifier compraPaga() {
        require(pago);
        _;
    }

    function getVendedor() public view contratoAtivo returns (address) {
        return vendedor;
    }

    function getComprador() public view contratoAtivo compraPaga returns (address) {
        return comprador;
    }

    function getValor() public view contratoAtivo returns (uint){
        return valor;
    }
}
// SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

import "./Biblioteca.sol";

contract Leilao{

    using Biblioteca for *;

    enum State{Andamento, Falha, Sucesso, Pago} // Possíveis estados do leilão

    event LeilaoFinished(
        address addr,
        uint totalCollected,
        bool succeeded
    );

    string public name; //Nome do Leilão
    uint public targetAmount; // Valor mínimo de venda
    uint public deadline; // Tempo que o Leilão estará aberto
    address payable public beneficiario; // Endereço de carteira do beneficiário do Leilão
    State public estado; // Estado do leilão
    address public owner; //Vencedor do leilão 
    mapping(address => uint) public amounts; // mapeamento para os valores ofertados
    bool public collected; // 
    uint public totalCollected; // Total coletado no leilão.

    //Verificar o estado do contrato
    modifier inState(State expectedState){
        require(estado == expectedState, "Estado invalido");
        _;
    }


    constructor(string memory contractName, uint targetAmountETH, uint durationInMin, address payable benecifiaryAddress){
        name = contractName;
        targetAmount = Biblioteca.etherToWei(targetAmountETH);
        deadline = courrentTime() + Biblioteca.minutesToSeconds(durationInMin);
        beneficiario = benecifiaryAddress;
        owner = msg.sender;
        estado = State.Andamento;
    }

    // Calcular o valor coletado nos lances
    function contribute() public payable inState(State.Andamento){
        require(beforeDeadline(), "Nao sao permitidos lances apos o deadline");
        amounts[msg.sender] += msg.value;
        totalCollected += msg.value;

        if (totalCollected >= targetAmount){
            collected = true;
        }
    }

    //Mudar o estado do leilão após o seu fim
    function finishLeilao() public inState(State.Andamento){
        require(beforeDeadline(), "Nao sao permitidos lances apos o deadline");

        if(!collected){
            estado = State.Falha;
        } else{
            estado = State.Sucesso;
        }

        emit LeilaoFinished(address(this), totalCollected, collected);
    }

    // Coletar o valor final do leilão
    function collect() public inState(State.Sucesso){
        if(beneficiario.send(totalCollected)){
            estado = State.Pago;
        } else {
            estado = State.Falha;
        }
    }

    // Saque do valor do lance vendor
    function withdraw() public inState(State.Falha){
        require(amounts[msg.sender] > 0, "Nenhum lance foi ofertado");
        uint contributed = amounts[msg.sender];
        amounts[msg.sender] = 0;

        if(!msg.sender.send(contributed)){
            amounts[msg.sender] = contributed;
        }
    }

    funtion beforeDeadLine() public view returns(bool){
        return currenTime() < deadLine;
    }

    function currentTime() internal view returns(uints){
        return now;
    }

    function getTotalCollected() public view returns(uints){
        return totalCollected;
    }

    function inProgress() public view returns(bool){
        return estado == State.Andamento || estado == State.Sucesso;
    }

    function isSucessful() public view returns(bool){
        return estado == State.Pago;
    }
}
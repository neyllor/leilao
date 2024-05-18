var Leilao = artifacts.require("./Leilao.sol")

module.exports = function(deployer){
    deployer.deploy(
        Leilao,
        "Leilao Ferrari",
        1,
        20,
        "0x29eB912bba359df35BE731e438d1d3A4C855b2D6"
    )
}
require("dotenv").config();
const { ethers } = require("hardhat");

async function withdrawTokens() {
    const provider = new ethers.JsonRpcProvider(`https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`);

    const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

    const contractAddress = "0x1AFdaD6Ac74b117433aaA8C88EF95669839b7B0d";
    const fromAddress = "0x1dF6bE628F34a964AcFb695CD9F5417DBc95ff42";

    const Token = await ethers.getContractFactory("Token");
    const token = Token.attach(contractAddress);

    // Get the balance of the fromAddress
    const fromBalance = await token.balanceOf(fromAddress);
    console.log(`Balance of fromAddress: ${ethers.formatUnits(fromBalance, 18)}`);

    const tx = await token.connect(signer).withdraw(); // owner can withdraw the amount that they deposited based on mapping
    await tx.wait();

    // Get the updated balance after the transfer
    const updatedFromBalance = await token.balanceOf(fromAddress);
    console.log(`Updated balance of fromAddress: ${ethers.formatUnits(updatedFromBalance, 18)}`);

    // Get the total supply after the withdrawal
    const totalSupply = await token.totalSupply();
    console.log(`Total supply after withdrawal: ${ethers.formatUnits(totalSupply, 18)}`);

    console.log("Tokens withdrawn successfully");
}

withdrawTokens()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

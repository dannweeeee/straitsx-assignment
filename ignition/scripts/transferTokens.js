require("dotenv").config();
const { ethers } = require("hardhat");

async function transferTokens() {
    const provider = new ethers.JsonRpcProvider(`https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`);

    const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

    const contractAddress = "0x1AFdaD6Ac74b117433aaA8C88EF95669839b7B0d";
    const fromAddress = "0x1dF6bE628F34a964AcFb695CD9F5417DBc95ff42";
    const toAddress = "0x753247b43dE9adA44338061F2564c55a2E49884F";

    const Token = await ethers.getContractFactory("Token");
    const token = Token.attach(contractAddress);

    // Get the balance of the fromAddress
    const fromBalance = await token.balanceOf(fromAddress);
    console.log(`Balance of fromAddress: ${ethers.formatUnits(fromBalance)}`);

    // Get the balance of the toAddress
    const toBalance = await token.balanceOf(toAddress);
    console.log(`Balance of toAddress: ${ethers.formatUnits(toBalance)}`);

    const amount = 1000;
    const tx = await token.connect(signer).transfer(toAddress, amount);
    await tx.wait();

    // Get the updated balances after the transfer
    const updatedFromBalance = await token.balanceOf(fromAddress);
    console.log(`Updated balance of fromAddress: ${ethers.formatUnits(updatedFromBalance)}`);

    const updatedToBalance = await token.balanceOf(toAddress);
    console.log(`Updated balance of toAddress: ${ethers.formatUnits(updatedToBalance)}`);

    console.log("Tokens transferred successfully");
}

transferTokens()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

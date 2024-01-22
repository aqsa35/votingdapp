import React,{useState,useEffect} from 'react';
import Web3Modal from"web3modal";
import { ethers } from 'ethers';
import {create as ipfsHttpClient} from "ipfs-http-client";
import axios from "axios";
import { useRouter } from "next/router";
//   INTERNAL IMPORT
    import { VotingAddress,VotingAddressABI } from "./constants";

    const fetchContract = (signerOrProvider)=>
    new ethers.Contract(VotingAddress,VotingAddressABI,signerOrProvider);
    // ye function fetch kare ga contract ky functions ko 
     export const VotingContext = React.createContext();
     export const VotingProvider = ({children})=>{
        const votingTitle = "My first smart contract app"; // make it comment later
        const router = useRouter();
        const[currentAccount, setCurrentAccount]= useState(""); 
        const[candidateLength, setCandidateLength]= useState("");
        const pushCandidate = [];
        const candidateIndex = [];
        const[candidateArray, setCandidateArray]= useState(pushCandidate);

//-----------------END OF CANDIDATE DATA ------------------

//-------------------ERROR MESSAGE -------------------
const[error, setError]= useState("");
const highestVote =[];

// ----------------VOTER SECTION-----------------------
const pushVoter =[];
const [voterArray, setVoterArray] = useState(pushVoter);
const [voterLength, setVoterLength] = useState("");
const [voterAddress, setVoterAddress] = useState([]);

//-------------CONNECTING METAMASK--------------------
const checkIfWalletIsConnected = async() => {
    if(!window.ethereum) return setError("Please Install MetaMask");
    const account = await window.ethereum.request({method:"eth_accounts"});

    if(account.length){
        setCurrentAccount(account[0]);
      //   getAllVoterData();
      //   getNewCandidate();
      }
        else{
             setError("Please Install MetaMask & Connect,Reload");
        }
    };
//----------CONNECT WALLET--------------------------
const connectWallet = async()=>{
    if(!window.ethereum) return setError("Please Install MetaMask");

    const accounts = await window.ethereum.request({
        method:"eth_requestAccounts",
    });
      setCurrentAccount(account[0]);
      // getAllVoterData();
      // getNewCandidate();
};
//--------------UPLOAD TO IPFS VOTER IMAGE------------------
const uploadToIPFS = async(file)=>{
   if (file){
      try{
         const formData = new FormData();
         formData.append("file", file);
         const response = await axios({
            method: "post",
            url:"http://api.pinata.cloud/pinning/pinFileToIPFS",
            data:formData,
            headers:{
               pinata_api_key:`e36139cffb67430af128`,
               pinata_secret_api_key:`96df8778e719922b2bac806f1895d36311bc8dc3fa305ede8277cb3f33eca2f6`,
               "Content-Type":"multipart/form-data",
            },
         });
         const ImgHash= `https://gateway.pinata.cloud/ipfs/${response.data.IpfsHash}`;
         return ImgHash;
      }
      catch(error){
         console.log ("Unable to upload image to Pinata");
      }
   }};
        return(
            <VotingContext.Provider
             value={{votingTitle,checkIfWalletIsConnected,connectWallet,uploadToIPFS,}}
             >
                {children}
                </VotingContext.Provider>
                );
      };

//export default Voter;
    
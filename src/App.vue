<template>
  <div v-bind:style="{ background: activeColor}">
  <div class="container">
    <div class="b-row">

          <label for="donation">
			  <br>
			  <h4>
            <b>Donation</b>:
			  </h4>
          </label>
          <b-form-input
            id="donation"
            v-model="donation"
            type="text"
            placeholder="donation in ETH"
          />
        </div>
		<br>
    <div class="b-row">
      <div>
        <b-button
          :variant="'primary'"
          @click="donate"
        >
          {{ donateStatus }}
        </b-button>
        <img
          v-show="isLoad"
          src="https://media.giphy.com/media/2A6xoqXc9qML9gzBUE/giphy.gif"
        >
		<br><br>

		<a v-bind:href="txHashUrl" target="blank"> {{txHashUrl}} </a>

      </div>
    </div>
	  <hr>
	  <h4>

You are on {{ chain }}. 
<br><br>
The current balance in the smart contract is {{balanceEther}} ether.

	  </h4>
	  <br><br>

    </div>
  </div>
</template>

<script>
import web3 from '../contracts/web3';
import crowdfundBox from '../contracts/crowdfundBoxInstance';
import chains from './assets/chains.json'

export default {
  name: 'APP',
  data() {
    return {
		activeColor: '#e6f2ff',
		donation: '',
		balance: '',
		balanceEther: '',
		isLoad: false,
		donateStatus: "DONATE",
		txHash: '',
		txHashUrl: '',
		chainId: '',
		chain: '',
		chainsList: chains
    };
  },
  beforeMount() {
	web3.eth.net.getId().then((chainId) => {
		this.chainId = chainId
		for (let i = 0; i < this.chainsList.length; i++){
			if (this.chainsList[i].networkId == chainId){
				this.chain = this.chainsList[i].name
			}
		}
	});

    // get crowdfundBox method: balance()
    crowdfundBox.methods
      .balance()
      .call()
      .then((_balance) => {
        console.log(_balance);
        // set the balance of contract
		this.balance = _balance;
		this.balanceEther = web3.utils.fromWei(this.balance, 'ether');
    });
  },
  methods: {
    donate() {
      // get accounts
      web3.eth.getAccounts().then((accounts) => {
		// convert 'ether' to 'wei'
		const donation = web3.utils.toWei(this.donation, 'ether');
		// donate in CrowdfundBox contract
		this.isLoad = true;
		return crowdfundBox.methods.donate()
		.send({ from: accounts[0], value: donation });
	  }).then((receipt)=>{
		  this.isLoad = false;
		  this.balance += donation;
		  this.balanceEther = web3.utils.fromWei(this.balance, 'ether');
		  this.txHash = 'txHash: ' + receipt.transactionHash;	this.txHashUrl = "https://kovan.etherscan.io/tx/" + receipt.transactionHash 
 
	  }
	  )
	  .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>

<style>
#app {
  font-family: 'Courier New', Courier, monospace;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;

}

h1, h2, h4 {
	font-family: 'Courier New', Courier, monospace;
	font-weight: normal;
}

ul {
  font-family: 'Courier New', Courier, monospace;
  list-style-type: none;
  padding: 0;
}

li {
  font-family: 'Courier New', Courier, monospace;
  display: inline-block;
  margin: 0 10px;
}

a {
  font-family: 'Courier New', Courier, monospace;
  color: #42b983;
}

input, label {
	font-family: 'Courier New', Courier, monospace;
}

button {
  font-family: 'Courier New', Courier, monospace;
}

button:hover {
  background-color: white; /* Green */
  color: #b64d5b;
  border: #b64d5b 2px solid;

}



img {
  width: 32px;
}


</style>

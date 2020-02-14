<template>
  <div v-bind:style="{ background: activeColor}">
  <div class="container">
    <div class="b-row">
      <div>
		<br>
        <h1>
			Virgil Griffith's<br> legal fundraiser
        </h1>
        <hr>
		<h6>
		We are raising funds for the legal defense of Virgil Griffith, a cryptocurrency researcher and educator. Funds raised will go directly to the Griffith family to offset legal fees.
		<br><br>

		After presenting a cryptocurrency talk in North Korea in 2019, Virgil was charged by a US grand jury with conspiracy to violate the International Emergency Economic Powers Act. He was arrested and detained for six weeks, and has since been released on bail. Virgil is living with his family in Alabama while preparing for trial.

		<br><br>

		The indictment filing can be viewed at: <br><a href="https://www.scribd.com/document/44226123`7/Virgil-Griffith-Indictment" target="blank">https://www.scribd.com/document/44226123`7/Virgil-Griffith-Indictment</a>
		</h6>
		<hr>

        <div>

          <label for="donation">
            <b>Donation</b>:
          </label>
          <b-form-input
            id="donation"
            v-model="donation"
            type="text"
            placeholder="donation in ETH"
          />
        </div>
		<br>
      </div>
    </div>
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
	  <h6>
	  Your donations are being held in an Ethereum smart contract at <a href="https://kovan.etherscan.io/address/0xe25776f5fb43d602e2829aa37d257fa35372e0cd#code" target="blank">0xE25776f5fB43d602e2829AA37D257fA35372e0Cd</a>. Its current balance is {{balance}} wei.<br><br>
	  The balance can only be withdrawn by the key _______________________, which is verified to be held by Robert Griffith (father of Virgil Griffith).
	  </h6>
	  <br><br>

    </div>
  </div>
</template>

<script>
import web3 from '../contracts/web3';
import crowdfundBox from '../contracts/crowdfundBoxInstance';

export default {
  name: 'APP',
  data() {
    return {
		activeColor: '#e6f2ff',
		donation: '',
		balance: '',
		isLoad: false,
		donateStatus: "DONATE",
		txHash: '',
		txHashUrl: ''
    };
  },
  beforeMount() {
    // get crowdfundBox method: balance()
    crowdfundBox.methods
      .balance()
      .call()
      .then((_balance) => {
        console.log(_balance);
        // set the balance of contract
        this.balance = _balance;
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

h1,
h2, h6 {
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


ensure to copy/paste .env_sample.json to .env.json in the root (where the package.json is at)
ensure to copy/paste .env.sample so you have a .env in the root

npm install
npm install -g truffle

ensure you have ganache... preferably ganache cli and/or running docker.   that said, ganache ui desktop app is fine too, just a little slower
ensure ganache is listening on 8545 (or, change the truffle-config.js to set whatever port you want... or set up wahtever network provider you want)

if network is setup, then run
truffle test

to see more logs, add this to ensure emitted contract events show up
test truffle   --show-events

# Details

This smart contract is a representation of a completely decentralized ico launchpad protocol, aiming to provide a safe and fair distribution of tokens and ETH during an ICO process. The idea behind is the implementation of a faster, fficient with better security and  speed while preventing investors from being burned with RUGS and/or whales, while also allowing new projects an easy way to kickstart their idea and dreams.

## How it works ?
 working on this, will add it once i'm done... we  need to specify how the  % works and  forcing limit of number  of % of  total supply to a finite  option with minimum of 10% and max or 30%.   Any project whose supply tokens offered in the presale that that passes softcap but misses hardcap will have the  remaining tokens burned.   

 Additionally, the project developer/marketing (and  other teams) will have it's own tokens in a time locked wallet which will have %'s being released over time.     

 Any  contract that  is offered on our  presale will have a sale  tax for   the   first 1  months of 20%.   Beyond that, the tax will be decrease by 1% every week, with no tax at 6 months of going successfully completed ICO (date starts at the IDO  part).   


# To see emitted events from the contract, you have to add "--show-events" as part of the truffle request
truffle test --show-events

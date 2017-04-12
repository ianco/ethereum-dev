DOCKER_RUN=docker run -d -it
DOCKER_ALICE=$(DOCKER_RUN) -p 8080:8080 -p 30303:30303 -p 1998:1998 --name=alice --hostname=alice
DOCKER_BOB  =$(DOCKER_RUN) -p 8081:8081 -p 30304:30304 -p 1999:1999 --name=bob --hostname=bob

GOPATH=/home/osboxes/go
ETHEREUM_SRC=$(GOPATH)/src/github.com/ethereum/go-ethereum
ETHEREUM_DATA=/home/osboxes/Ethereum

BASE_IMG=anon-sol/ethereum-dev-base
RUN_BASE_IMG=run-ethereum-dev-base
IMG=anon-sol/ethereum-dev

ALICE_DAEMON=geth --identity "alice" --rpc --rpcport "8080" --rpccorsdomain "*" --datadir "$(ETHEREUM_DATA)" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1998 console
BOB_DAEMON=geth --identity "bob" --rpc --rpcport "8081" --rpccorsdomain "*" --datadir "$(ETHEREUM_DATA)" --port "30304" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 console

RUN_SHELL=bash

build-base:
	docker build -t $(BASE_IMG) base

run-base:
	docker run -d -it -v $(ETHEREUM_SRC):$(ETHEREUM_SRC) -w $(ETHEREUM_SRC) -e "GOPATH=$(GOPATH)" --name $(RUN_BASE_IMG) $(BASE_IMG) bash

stop-base:
	docker stop $(RUN_BASE_IMG)

install-base:
	docker exec $(RUN_BASE_IMG) go install -v ./...

commit-base:
	docker commit $(RUN_BASE_IMG) $(IMG)

alice_rm:
	-docker rm -f alice

bob_rm:
	-docker rm -f bob

alice_shell: alice_rm
	$(DOCKER_ALICE) -it $(IMG) $(RUN_SHELL)

bob_shell: bob_rm
	$(DOCKER_BOB) -it $(IMG) $(RUN_SHELL)

bob_init: 
	docker exec bob geth --datadir "$(ETHEREUM_DATA)" init $(ETHEREUM_DATA)/testnet/genesisblock.json 
	docker exec bob geth --datadir "$(ETHEREUM_DATA)" --password /home/osboxes/passwd.txt account new

bob_daemon: 
	docker exec bob $(BOB_DAEMON)

bob_cmd:
	docker exec bob geth $(ecmd)

alice_init: 
	docker exec alice geth --datadir "$(ETHEREUM_DATA)" init $(ETHEREUM_DATA)/testnet/genesisblock.json 
	docker exec alice geth --datadir "$(ETHEREUM_DATA)" --password /home/osboxes/passwd.txt account new

alice_daemon: 
	docker exec alice $(ALICE_DAEMON) 

alice_cmd:
	docker exec alice geth --datadir "$(ETHEREUM_DATA)" $(ecmd)



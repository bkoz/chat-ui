```
oc new-app --image=docker.io/mongo:latest
```
```
oc new-app https://github.com/bkoz/chat-ui.git --env=MONGODB_URL=mongodb://mongo:27017 --env=HF_ACCESS_TOKEN=hf_access_token
``
We will attempt the following changes from the upstream Mutexo:
- Push ledger state tip to listeners instead of pulling
- Add mempool monitoring to "look in the future" so we can share mempool tip instead of block tip
  - This means more rollbacks 

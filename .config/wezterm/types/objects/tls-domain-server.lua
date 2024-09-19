---@class TlsDomainServer
---@field bind_address String
-- The address:port combination on which the server will listen
-- for client connections
---@field pem_private_key PathBuf
-- the path to an x509 PEM encoded private key file
---@field pem_cert PathBuf
-- the path to an x509 PEM encoded certificate file
---@field pem_ca PathBuf
-- the path to an x509 PEM encoded CA chain file
---@field pem_root_certs PathBuf[]
-- A set of paths to load additional CA certificates.
-- Each entry can be either the path to a directory
-- or to a PEM encoded CA file.  If an entry is a directory
-- then its contents will be loaded as CA certs and added
-- to the trust store.
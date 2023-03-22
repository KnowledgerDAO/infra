const { SecretClient } = require('@azure/keyvault-secrets');
const { DefaultAzureCredential } = require('@azure/identity');
const { createPow } = require('@textile/powergate-client');

const host = process.argv.slice(2)[0];

async function main() {
  const credential = new DefaultAzureCredential();

  const keyVaultName = 'teste-bridgez';
  const url = 'https://' + keyVaultName + '.vault.azure.net';

  const client = new SecretClient(url, credential);

  const token = await getTokenFromPowergate();
  const uniqueString = new Date().getTime();
  const secretName = `powergate-token`;
  const result = await client.setSecret(secretName, token);

  // Read the secret we created
  const secret = await client.getSecret(secretName);

  
  const updatedSecret = await client.updateSecretProperties(
    secretName,
    result.properties.version,
    {
      enabled: true,
    },
  );



}

main().catch((error) => {
  console.error('An error occurred:', error);
  process.exit(1);
});

async function getTokenFromPowergate() {
  const pow = createPow({ host });
  pow.setAdminToken('<an admin auth token>');
  const { user } = await pow.admin.users.create(); // save this token for later use!
  return JSON.stringify(user);
}

getTokenFromPowergate();

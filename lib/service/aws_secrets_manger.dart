import 'package:aws_secretsmanager_api/secretsmanager-2017-10-17.dart';
import 'package:wsac/service/amplify_service/amplify_configuration.dart';

import '../repository/authentication_repo.dart';

class AWSSecretsManger {
  static final SecretsManager secretManager = SecretsManager(
    region: cognitoIdentityRegion,
    endpointUrl: graphQlUrl,
  );

  Future<void> createAwsSecret(String name) async {
    final value = await AuthenticationRepo().getRefreshToken();
    secretManager.createSecret(
      name: name,
      clientRequestToken: value!.accessToken.toString(),
    );
  }

  Future<void> getAwsSecret(String secretId) async {
    secretManager.getSecretValue(secretId: secretId);
  }

  Future<void> deleteAwsSecret(String secretId) async {
    secretManager.deleteSecret(secretId: secretId);
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

///cognito
final String cognitoUserPoolAppClientId =
    dotenv.env['COGNITO_USER_POOL_APP_CLIENT_ID']!;
final String cognitoUserPoolId = dotenv.env['COGNITO_USER_POOL_ID']!;
final String cognitoIdentityPoolId = dotenv.env['COGNITO_IDENTITY_POOL_ID']!;

///region
final String cognitoIdentityRegion = dotenv.env['COGNITO_REGION']!;
final String cognitoUserPoolRegion = dotenv.env['COGNITO_REGION']!;
final String s3BucketRegion = dotenv.env['BUCKET_REGION']!;

final String amplifyAuth = dotenv.env['AMPLIFY_AUTH']!;
final String appCognitoOauthDomainUrl =
    dotenv.env['APP_COGNITO_OAUTH_DOMAIN_URL']!;

///redirection uri
final String signInRedirectURI = dotenv.env['SIGN_IN_REDIRECT_URI']!;
final String signOutRedirectURI = dotenv.env['SIGN_OUT_REDIRECT_URI']!;

///s3 bucket
final String s3BucketName = dotenv.env['BUCKET_NAME']!;

///graphQl
final String graphQlUrl = dotenv.env['GRAPHQL_URL']!;
//api name
final String graphQlApiName = dotenv.env['GRAPHQL_API_NAME']!;
final String restApiName = dotenv.env['REST_API_NAME']!;

///config json
final amplifyConfigString = {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": {"Default": <String, dynamic>{}},
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": cognitoIdentityPoolId,
              "Region": cognitoIdentityRegion
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": cognitoUserPoolId,
            "AppClientId": cognitoUserPoolAppClientId,
            "Region": cognitoUserPoolRegion
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": amplifyAuth,
            "OAuth": {
              "WebDomain": appCognitoOauthDomainUrl,
              "AppClientId": cognitoUserPoolAppClientId,
              "SignInRedirectURI": signInRedirectURI,
              "SignOutRedirectURI": signOutRedirectURI,
              "Scopes": [
                "phone",
                "email",
                "openid",
                "profile",
                // "aws.cognito.signin.user.admin"
              ]
            }
          }
        }
      }
    }
  },
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        graphQlApiName: {
          "endpoint": graphQlUrl,
          "graphql_endpoint": graphQlUrl,
          "region": cognitoUserPoolRegion,
          "endpointType": "GraphQL",
          "authorizationType": "AMAZON_COGNITO_USER_POOLS"
        }
        // restApiName: {
        //   "endpointType": "REST",
        //   "endpoint": "http://localhost:5000/api/v1",
        //   "region": cognitoUserPoolRegion,
        //   "authorizationType": "AMAZON_COGNITO_USER_POOLS"
        // }
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {"bucket": s3BucketName, "region": s3BucketRegion}
    }
  }
};

//mutation queries here

import 'queries.dart';

///create user
const String createUserQuery = """
  mutation createUser(
    \$cognitoId: String!
    \$email: AWSEmail!
    \$emailVerified: Boolean!
    \$firstName: String!
    \$lastName: String!
    \$phone:String!
    \$phoneVerified: Boolean!
		\$socialMediaType: userSocialMedia
		\$socialMediaID: String
		\$gender: userGender
		\$dateOfBirth: AWSDateTime
		\$postCode: String
		\$addressLine1: String
		\$town: String
		\$avatarImage: AWSURL
    \$userType: userType!
    \$trader: traderInput
    \$userLocation:locationInput
  ) {
  createUser(
    cognitoId: \$cognitoId,
    email:  \$email,
    emailVerified:  \$emailVerified,
    firstName:  \$firstName,
    lastName: \$lastName,
    phone:  \$phone,
    phoneVerified: \$phoneVerified,
    socialMediaType: \$socialMediaType,
		socialMediaID: \$socialMediaID,
		gender: \$gender,
		dateOfBirth: \$dateOfBirth,
		postCode: \$postCode,
		addressLine1: \$addressLine1,
		town: \$town,	
		avatarImage: \$avatarImage,
    userType:\$userType
    trader:\$trader
    userLocation:\$userLocation
    ) {
    $userAttributes
   }
  }
  """;

const String updateUserQuery = """
mutation updateUser(
    \$_id: String! 
    \$addressLine1: String
    \$avatarImage: AWSURL
    \$contract: String 
    \$dateOfBirth: AWSDateTime
    \$emailVerified: Boolean
    \$firstName: String
    \$gender: userGender
    \$lastName: String
    \$notificationStatus: userNotificationStatus
    \$phoneVerified: Boolean
    \$postCode: String
    \$slug: String
    \$status: userStatus
    \$town: String 
    \$traderId: String
    \$trader: traderInput
    \$userName: String
    \$userPurpose: userPurpose
    \$userType: userType
    ){
      updateUser(
        _id :\$_id 
        addressLine1:\$addressLine1
        avatarImage:\$avatarImage
        contract:\$contract
        dateOfBirth:\$dateOfBirth
        emailVerified:\$emailVerified
        firstName:\$firstName
        gender:\$gender
        lastName:\$lastName
        notificationStatus:\$notificationStatus
        phoneVerified:\$phoneVerified
        postCode :\$postCode 
        slug:\$slug
        status:\$status
        town:\$town
        traderId:\$traderId
        trader:\$trader
        userName:\$userName
        userPurpose:\$userPurpose
        userType:\$userType
    ) {
      $userAttributes
  }
}
""";

// Delete an User
const String deleteUserMutation = """
  mutation deleteUser(
    \$userId: String!, 
  ) {
    deleteUser(
    userId: \$userId, 
    ) {
      _id
      dateOfBirth
      email
      firstName
      gender
      lastName
      phone
      cognitoId
      createdAt
      userType
      trader {
        _id
        companyName
        companyDescription
      }
      traderId
    }
  }
  """;

const String createCarQuery = """
  mutation createCar(
    \$registration: String!,
		\$mileage: Int!,
		\$exteriorGrade: carExteriorGradeInput!,
		\$userId: String!,
		\$userType: carUserType!,
		\$createStatus: [carCreateStatus]!,
		\$carLocation: locationInput!,
		\$tradeValue: Float!,
		\$wsacValue: Float!,
		\$addedAccessories: carAddedAccessoriesDataInput!,
		\$manufacturer: valuesSectionInput!,
		\$model: String!,
		\$yearOfManufacture: Int!,
		\$colour: valuesSectionInput!,
		\$transmissionType: valuesSectionInput!,
    \$hpiAndMot: carHpiAndMotInput,
		\$engineSize: Float!,
		\$fuelType: valuesSectionInput!,
    \$bodyType: valuesSectionInput!,
		\$additionalInformation: additionalInformationInput!,
    \$doors: Int,
		\$ownerProfileImage: AWSURL,
		\$ownerUserName: String,
		\$userRating: Float,
		\$userExpectedValue: Float,
		\$quickSale: Boolean,
    \$numberOfGears: Int,
		\$numberOfSeats: Int
  ) {
  createCar(
    registration: \$registration,
		mileage: \$mileage,
		exteriorGrade: \$exteriorGrade,
		userId: \$userId,
		userType: \$userType,
		createStatus: \$createStatus,
		carLocation: \$carLocation,
		tradeValue: \$tradeValue,
		wsacValue: \$wsacValue,
		addedAccessories: \$addedAccessories,
		manufacturer: \$manufacturer,
		model: \$model,
		yearOfManufacture: \$yearOfManufacture,
		colour: \$colour,
		transmissionType: \$transmissionType,
    hpiAndMot: \$hpiAndMot,
		engineSize: \$engineSize,
		fuelType: \$fuelType,
    bodyType: \$bodyType,
		additionalInformation: \$additionalInformation,
    doors: \$doors,
		ownerProfileImage: \$ownerProfileImage,
		ownerUserName: \$ownerUserName,
		userRating: \$userRating,
		userExpectedValue: \$userExpectedValue,
		quickSale: \$quickSale,
    numberOfGears: \$numberOfGears,
		numberOfSeats: \$numberOfSeats
    ) {
     $carAttributes
  }
}
""";

const String updateCarQuery = """
  mutation updateCar(
    \$_id: String!,
		\$addedAccessories: carAddedAccessoriesDataInput,
		\$additionalInformation: additionalInformationInput,
    \$premiumPost: premiumPostInput,
		\$userExpectedValue: Float,
		\$quickSale: Boolean,
		\$hpiAndMot: carHpiAndMotInput,
		\$serviceHistory: carServiceHistoryInput,
		\$conditionAndDamage: carConditionAndDamageInput,
		\$uploadPhotos: carUploadPhotosInput,
		\$postType: carPostType,
		\$surveyQuestions: String,
		\$createStatus: [carCreateStatus],
    \$model: String,
    \$manufacturer: valuesSectionInput,
    \$yearOfManufacture: Int,
    \$colour: valuesSectionInput,
    \$transmissionType: valuesSectionInput,
    \$engineSize: Float,
    \$fuelType: valuesSectionInput,
    \$bodyType: valuesSectionInput,
    \$doors: Int,
    \$numberOfGears: Int,
		\$numberOfSeats: Int
  ) {
  updateCar(
    _id: \$_id,
		addedAccessories: \$addedAccessories,
		additionalInformation: \$additionalInformation,
    premiumPost: \$premiumPost,
		userExpectedValue: \$userExpectedValue,
		quickSale: \$quickSale,
		hpiAndMot: \$hpiAndMot,
		serviceHistory: \$serviceHistory,
		conditionAndDamage: \$conditionAndDamage,
		uploadPhotos: \$uploadPhotos,
		postType: \$postType,
		surveyQuestions: \$surveyQuestions,
		createStatus: \$createStatus,
    model: \$model,
    manufacturer: \$manufacturer,
    yearOfManufacture: \$yearOfManufacture,
    colour: \$colour,
    transmissionType: \$transmissionType,
    engineSize: \$engineSize,
    fuelType: \$fuelType,
    bodyType: \$bodyType,
    doors: \$doors,
    numberOfGears: \$numberOfGears,
		numberOfSeats: \$numberOfSeats
    ) {
    $carAttributes
  }
}
""";

const String addSubscriptionRequest = """
  mutation addSubscriptionRequest(
    \$email: AWSEmail!,
    \$firstName: String!
    \$lastName: String
    \$town: String
		\$companyName: String!,
		\$traderId: String!,
		\$planName: String!,
		\$planType: String!,
		\$planId: String!,
		\$userId: String!,
    \$upcomingPlanId: String
  ) {
  addSubscriptionRequest(
    email: \$email,
    firstName:\$firstName
    lastName:\$lastName
    town:\$town
		companyName: \$companyName,
		traderId: \$traderId,
		planName: \$planName,
		planType: \$planType,
		planId: \$planId,
		userId: \$userId,
    upcomingPlanId: \$upcomingPlanId
    ) {
    companyName
    createdAt
    email
    planId
    planName
    planType
    status
    traderId
    updatedAt
    updatedBy
    userId
  }
}
""";

//Cancel Subscription
const String cancelSubscriptionRequest = """
  mutation cancelSubscription(
    \$email: AWSEmail!,
		\$companyName: String!,
		\$traderId: String!,
		\$planName: String!,
		\$planType: String!,
		\$planId: String!,
		\$userId: String!,
  ) {
  cancelSubscription(
    email: \$email,
		companyName: \$companyName,
		traderId: \$traderId,
		planName: \$planName,
		planType: \$planType,
		planId: \$planId,
		userId: \$userId,
    ) {
    _id
    companyName
    createdAt
    email
    planId
    planName
    planType
    status
    traderId
    updatedAt
    updatedBy
    userId
  }
}
""";

//Report issue mutation
const String reportIssueMutation = """
  mutation reportIssue(
    \$description: String!, 
    \$reportedBy: String!, 
    \$subject: String!, 
    \$reportedTo: String
  ) {
    reportIssue(
    description: \$description, 
    reportedBy: \$reportedBy, 
    subject: \$subject, 
    reportedTo: \$reportedTo
    ) {
      _id
      description
      reportedBy
      status
      subject
    }
  }
  """;

//Report issue mutation
const String submitNeedFinanceRequest = """
  mutation addFinanceRequest(
    \$amount: String!, 
    \$transactionId: String!, 
    \$userEmail: AWSEmail!, 
    \$userId: String!,
    \$userName: String!,
  ) {
    addFinanceRequest(
    amount: \$amount, 
    transactionId: \$transactionId, 
    userEmail: \$userEmail, 
    userId: \$userId, 
    userName: \$userName
    ) {
      _id
      amount
      createdAt
      transactionId
      status
      updatedAt
      updatedBy
      userEmail
      userId
      userName
    }
  }
  """;

//Like A Car
const String likeACarMutation = """
  mutation likeACar(
		\$carId: String!,
		\$ownerId: String!,
		\$ownerType: userType!
	) {
    likeACar(
		carId: \$carId,
		ownerId: \$ownerId,
		ownerType: \$ownerType
	  ) {
      $carLikesAttributes
    }
  }
  """;

//DisLike A Car
const String disLikeACarMutation = """
  mutation dislikeACar(
		\$carId: String!
	) {
    dislikeACar(
		  carId: \$carId
	  )
  }
  """;

//Unlike A Car
const String unlikeACarMutation = """
  mutation unLikeACar(
    \$carId: [String]!, 
    \$userId: String!,
    \$deleteAll: Boolean!,
  ) {
    unLikeACar(
    carId: \$carId, 
    userId: \$userId, 
    deleteAll: \$deleteAll
    )
  }
  """;

///Delete car
const String deleteCarMutation = """
  mutation deleteCar(\$_id: String!) {
    deleteCar(_id: \$_id) {
      _id
    }
  }
  """;

const String upgradeToDealerRequest = """
  mutation upgradeToTrader(
    \$planId: String!,
    \$planName: String!,
    \$planType: String!,
    \$userId: String!,
    \$trader: traderInput,
    \$upcomingPlanId: String
  ) {
     upgradeToTrader(
    planId: \$planId,
    planName:\$planName,
    planType:\$planType,
    userId:\$userId,
		trader: \$trader,
    upcomingPlanId: \$upcomingPlanId
    ) {
     _id
    addressLine1
    avatarImage
    cognitoId
    contract
    createdAt
    dateOfBirth
    email
    emailVerified
    existingPurpose
    firstName
    gender
    lastName
    notificationStatus
    phone
    phoneVerified
    postCode
    slug
    phoneNumberChange {
      requestId
      status
      updatedAt
    }
    socialMediaID
    socialMediaType
    status
    town
    traderId
    updatedAt
    updatedBy
    upgradeToTrader {
      requestId
      status
      updatedAt
    }
    userName
    userPurpose
    userType
  }
}
""";

const String updateNotificationSettingsRequest = """
  mutation updateNotificationSettings(
    \$notificationType: notificationType!,
    \$status: notificationStatus!,
    \$userId: String!
  ) {
    updateNotificationSettings(
      notificationType: \$notificationType,
      status:\$status,
      userId:\$userId
    ) {
      $userAttributes
    }
  }
  """;

const String listCarQuery = """
  mutation listCar(
		\$_id: String!,
		\$userType: carUserType,
		\$status: carStatus!,
		\$userId: String!
	) {
    listCar(
      _id:\$_id,
      userType: \$userType,
      status: \$status,
      userId: \$userId
    ){
      $carAttributes
    }
  }
 """;

const String updateFeedbackAnswersMutation = """
  mutation updateFeedbackAnswers(
    \$userId: String!,
		\$carId: String,
		\$traderId: String,
		\$type: surveyType!,
    \$answers: [feedbackAnswersInput]
    ) {
      updateFeedbackAnswers(
        userId: \$userId,
		    carId : \$carId,
		    traderId : \$traderId,
		    type : \$type,
        answers: \$answers
      ) {
    _id
    carId
    traderId
    type
    userId
    answers {
      ansType
      multiAnswer
      question
      questionId
      textAnswer
      yesOrNoAnswer
    }
    }
  }
  """;

const String upgradeSubscriptionRequest = """
  mutation upgradeSubscriptionRequest(
    \$companyName: String!,
    \$email: AWSEmail!,
    \$planId: String!,
    \$firstName: String!,
    \$planName: String!,
    \$planType: String!,
    \$traderId: String!,
    \$userId: String!,
  ) {
     upgradeSubscriptionRequest(
      companyName: \$companyName,
      email: \$email,
      planId: \$planId,
      firstName: \$firstName,
      planName:\$planName,
      planType:\$planType,
      traderId:\$traderId,
      userId:\$userId,
    ) {
     _id
    companyName
    email
    firstName
    lastName
    planId
    planName
    planType
    status
    town
    traderId
    userId
  }
}
""";

String updateTransactionStatusQuery() {
  return """
  mutation updateTransactionStatus(\$_id: String!, \$status: transactionStatus, \$amount: Float) {
  updateTransactionStatus(_id: \$_id, status: \$status, amount: \$amount)
  {
  _id
  status
  }
}
""";
}

String createTransactionQuery() {
  return """
  mutation createTransaction(
    \$sellerId: String,
		\$buyerId: String,
		\$sellerCarId: String,
		\$buyerCarIds: [transactionBuyerCarIdsInput],
		\$type: transactionType,
		\$amount: Float,
		\$payBy: transactionPayBy,
		\$status: transactionStatus,
		\$createdBy: String
	)
	{
  createTransaction(
		sellerId: \$sellerId,
		buyerId: \$buyerId,
		sellerCarId: \$sellerCarId,
		buyerCarIds: \$buyerCarIds,
		type: \$type,
		amount: \$amount,
		payBy: \$payBy
		status: \$status
		createdBy: \$createdBy
	)
	{
    _id
    status
	}
	}
""";
}

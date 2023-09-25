//queries here

// ignore_for_file: leading_newlines_in_multiline_strings

const String userAttributes = """ 
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
    notificationSettings {
      notifications
    }
    phone
    phoneVerified
    postCode
    slug
    socialMediaID
    socialMediaType
    status
    town
    phoneNumberChange {
      requestId
      status
      updatedAt
    }
    upgradeToTrader {
      requestId
      status
    }
    trader {
      _id
      addressLine1
      companyContact
      companyDescription
      companyName
      companyWebsiteUrl
      adminUserId
      createdAt
      email
      logo
      phone
      totalCarLimit
      carsListed
      status
      cancelSubscription {
        requestId
        status
      }
      subscription {
        cycle
        cycleType
        endsOn
        id
        name
        status
        type
        amount
        carLimit
        updatedOn
      }
      subscriptionChangeReq {
        planId
        planName
        status
      }
      upgradeSubscription {
        planId
        requestId
        status
        isInitialSubscription
      }
      payAsYouGo {
        amount
        carLimit
        carsListed
        validity
        cycleType
        endsOn
        id
        name
        status
        type
        updatedOn
      }
      town
      updatedAt
      updatedBy
      userLocation {
        coordinates
        type
      }
    }
    traderId
    updatedAt
    updatedBy
    userLocation {
      coordinates
      type
    }
    userName
    userPurpose
    userType
""";

//car attributes
const String carAttributes = """
    _id
    mileage
    model
    tradeValue
    wsacValue
    userExpectedValue
    quickSale
    slug
    userId
    status
    createStatus
    doors
    postType
    priceApproved
    surveyQuestions
    createdAt
    updatedAt
    updatedBy
    yearOfManufacture
    ownerProfileImage
	  ownerUserName
	  userRating
    userType
    companyName
    companyRating
    companyLogo
    engineSize
    additionalInformation {
      attentionGraber
      companyDescription
      description
    }
    addedAccessories {
      listed {
        exist
        id
        name
      }
      notListed {
        name
      }
    }
    analytics {
      likes
      matches
      offersReceived
      opens
      views
    }
    colour {
      id
      name
    }
    bodyType {
      id
      name
    }
    conditionAndDamage {
      additionalInfo
      brokenMissingItems {
        brokenMissingItems
        images
      }
      dents {
        dents
        images
      }
      lockWheelNut {
        images
        lockWheelNut
      }
      paintProblem {
        images
        paintProblem
      }
      scratches {
        images
        scratches
      }
      scuffedAlloy {
        images
        scuffedAlloy
      }
      smokingInVehicle {
        images
        smokingInVehicle
      }
      toolPack {
        images
        toolPack
      }
      tyreProblem {
        images
        tyreProblem
      }
      warningLightsDashboard {
        images
        warningLightsDashboard
      }
    }
    exteriorGrade {
      grade
      id
    }
    fuelType {
      id
      name
    }
    hpiAndMot {
      historyCheck {
        v5cDataQty
	      vehicleIdentityCheckQty
	      KeeperChangesQty
	      colourChangesQty
	      financeDataQty
	      cherishedDataQty
	      conditionDataQty
	      stolenVehicleDataQty
	      highRiskDataQty
	      isScrapped
      }
      firstRegisted
      keeperStartDate
      lastMotDate
      numberOfKeys
      onFinance
      previousOwner
      isPreOwnerNotDisclosed
      privatePlate
      registration
      sellerKeepingPlate
      vin
    }
    manufacturer {
      id
      name
    }
    registration
    serviceHistory {
      images
      independent
      mainDealer
      record
    }
    transmissionType {
      id
      name
    }
    uploadPhotos {
      adittionalImages
      bootSpaceImages
      frontImages
      interiorImages
      leftImages
      rearImages
      rightImages
      videos
    }
    premiumPost {
      amount
      expiry
      isPremium         
      transactionId
    }
    PremiumPostLogs {
      transactionId
      amount
      createdAt
      expiredAt
      createdBy
    }
""";
//get user data query
const String getUserDetails = """
  query getUserDetails(
    \$key: String!,
    \$value: String!
  ) {
      getUserDetails(
      key: \$key, 
      value: \$value
    ) {
    $userAttributes
   }
  }
  """;

//get Accessories [extra items added] query
const String getAccessoryDataQuery = """
  query getAccesoryData {
    getAccesoryData {
      _id
      createdAt
      name
      sortOrder
      status
      updatedAt
      updatedBy
   }
  }
  """;

//get Manufacturer list
const String getManufacturerDataQuery = """
  query listMasterTechnicalDetails {
    listMasterTechnicalDetails {
      manufacturers {
        _id
        createdAt
        name
        sortOrder
        status
        updatedAt
        updatedBy
        models {
          _id
          manufacturer
          createdAt
          name
          slug
          status
        }
      }
    }
  }
  """;

//get list master technical details
const String getTechnicalDetailsDataQuery = """
  query listMasterTechnicalDetails {
    listMasterTechnicalDetails {
      carColors {
        _id
        colorCode
        name
      }
      fuelTypes {
        _id
        name
      }
      bodyTypes {
        _id
        slug
        name
      }
      transmissionTypes {
        _id
        name
      }
    }
  }
  """;

//get Exterior Grades List query
const String getExteriorGradesListQuery = """
  query getExteriorGrade {
    getExteriorGrade {
      _id
      grade
      percentageValue
   }
  }
  """;

//get price approve percentage
const String getPriceApprovePercentage = """
  query MyQuery {
    getSystemConfigurations(key: "priceApprovePercentage")
  }
  """;

//get carDetails data query
const String getCarDetailsQuery = """
  query getCarDetails(
    \$key: String!,
    \$value: String!
  ) {
      getCarDetails(
      key: \$key, 
      value: \$value
    ) {
    $carAttributes
   }
  }
  """;

//get my car query
const String getMyCarsQuery = """
  query myCars(
    \$pageNo: Int!,
    \$perPage: Int!,
    \$filters: MyCarListingFilters
  ) {
    myCars(
      pageNo: \$pageNo,
      perPage: \$perPage,
      filters: \$filters
    ) {
      totalPages
      totalRecords
      pageNo
      paginationKey
      cars {
        $carAttributes
      }
    }
  }
  """;

//get subscription data query
const String getSubscriptionDataQuery = """
  query getSubscriptions {
   getSubscriptions {
    _id
    amount
    carLimit
    createdAt
    cycleType
    deleted
    description
    name
    sortOrder
    status
    type
    updatedAt
    updatedBy
    validity
    }
  }
  """;

//get issue types
const String getIssueTypes = """
  query MyQuery {
    getDisputeTypes {
      _id
      createdAt
      name
      status
      updatedAt
    }
  }
  """;

//get other cars by user query
const String getOtherCarsByUserQuery = """
  query otherCarsByUser(
    \$pageNo: Int!,
		\$perPage: Int!,
    \$exclude: String!, 
    \$userId: String!
  ) {
    otherCarsByUser(
      pageNo: \$pageNo,
		  perPage:\$perPage,
      exclude: \$exclude, 
      userId: \$userId
    ) {
      totalPages
      totalRecords
      pageNo
      cars {
        $carAttributes
      }
    }
  }
  """;

//get liked cars query
const String getLikedCarsQuery = """
  query likedCars(
    \$userId: String!,
		\$search: String,
		\$pageNo: Int!,
		\$perPage: Int!,
		\$sortBy: Int!,
		\$filters: LikedCarFilter
  ) {
     likedCars(
     userId: \$userId,
		 search: \$search,
		 pageNo: \$pageNo,
		 perPage:\$perPage,
		 sortBy: \$sortBy,
		 filters: \$filters
    )  {
       cars{
        $carLikesAttributes
       }
       totalPages
	     totalRecords
	     pageNo
    
  }
  }
  """;

//LikedCar Attributes
const String carLikesAttributes = """
	_id
   additionalInformation {
      attentionGraber
      companyDescription
      description
  }
  analytics {
      likes
      matches
      offersReceived
      opens
      views
  }
  userExpectedValue
  userName
  userType
  wsacValue
  yearOfManufacture
  avatarImage
  description
  carId
  carName
  companyDescription
  companyLogo
  companyName
  companyRating
  mileage
  model
  ownerId
  ownerType
  postType
  rating
  quickSale
  registration
  status
  bodyType {
    id
    name
  }
  likes
  likedBy
  image
  fuelType {
    id
    name
  }
  manufacturer {
    id
    name
  }
  transmissionType {
    id
    name
  }
  createdAt
  updatedAt
  updatedBy
  """;

//View matches query
const String getCarsQuery = """
  query getCars(
    \$listingParams: ListingParams
  ) {
    getCars(
      listingParams: \$listingParams
    ) {
      totalPages
      totalRecords
      pageNo
      paginationKey
      cars {
        $carAttributes
      }
    }
  }
  """;

//get faq questions query
const String getFaqQuestionsQuery = """
  query getFaqQuestions {
   getFaqQuestions {
    _id
    answer
    createdAt
    question
    sortOrder
    status
    type
    updatedAt
    updatedBy
    }
  }
  """;

//get feedback questions query
const String getFeedBackQuestionsQuery = """
query getFeedBackQuestions(\$type: String!)  {
  getFeedBackQuestions(type: \$type) {
    question
    ansType
    status
    type
    createdAt
    updatedAt
    updatedBy
    options
    _id
  }
}
  """;

//get premium posts query
const String getPremiumPostsQuery = """
  query getPremiumPosts(\$userType: filterUserTypes!) {
    getPremiumPosts(userType: \$userType) {
     _id
     amount
     description
     planName
     userType
     createdAt
     days
     status
     updatedAt
   }
  }
  """;

const String getMyMatchesQuery = """
  query getMyMatches(
    \$pageNo: Int!,
    \$perPage: Int!,
    \$sortBy: Int!,
    \$userId: String!
    ) {
    getMyMatches(
      pageNo: \$pageNo,
      perPage: \$perPage,
      sortBy: \$sortBy,
      userId: \$userId
      ) {
      myMatchesList {
      cars1 {
        $carLikesAttributes
      }
      cars2 {
        $carLikesAttributes
      }
    }
    pageNo
    totalPages
    totalRecords
    }
  }
  """;

const String getActiveUsersCountQuery = """
  query activeUsersCount {
    activeUsersCount {
      count
    }
  }
  """;

//get Expired car query
const String getExpiredCarQuery = """
  query expiredPremiumCars(
    \$pageNo: Int!,
    \$perPage: Int!,
    \$sortBy: Int!
  ) {
    expiredPremiumCars(
      pageNo: \$pageNo,
      perPage: \$perPage,
      sortBy: \$sortBy
    ) {
      totalPages
      totalRecords
      pageNo
      paginationKey
      cars {
        $carAttributes
      }
    }
  }
  """;

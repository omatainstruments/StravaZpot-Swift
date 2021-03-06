//
//  ActivityAPITest.swift
//  StravaZpot
//
//  Created by Tomás Ruiz López on 3/11/16.
//  Copyright © 2016 SweetZpot AS. All rights reserved.
//

import XCTest
import Nimble
@testable import StravaZpot

class ActivityAPITest: XCTestCase {
    
    func testShouldCreateAnActivity() {
        let client = MockHTTPClient(respondWithJSON: ACTIVITY_JSON)
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<Activity>?
        api.createActivity(withName: "Rowing session", withType: .rowing, withStartDate: Date(day: 20, month: 1, year: 2016, hour: 12, minute: 35, second: 46), withElapsedTime: Time(seconds: 6345), withDescription: "Relaxing training", withDistance: Distance(meters: 1234), isPrivate: false, withTrainer: true, withCommute: false).execute { result = $0 }
        
        expect(result).toEventually(beSuccessful())
        expect(client.lastUrl).to(contain("activities"))
        expect(client.postCalled).to(equal(true))
        expect(client.lastParameters["name"] as! String?).to(equal("Rowing session"))
        expect(client.lastParameters["type"] as! String?).to(equal("Rowing"))
        expect(client.lastParameters["start_date_local"] as! String?).to(equal("2016-01-20T12:35:46Z"))
        expect(client.lastParameters["elapsed_time"] as! Int?).to(equal(6345))
        expect(client.lastParameters["description"] as! String?).to(equal("Relaxing training"))
        expect(client.lastParameters["distance"] as! Double?).to(equal(1234))
        expect(client.lastParameters["private"] as! Bool?).to(equal(false))
        expect(client.lastParameters["trainer"] as! Bool?).to(equal(true))
        expect(client.lastParameters["commute"] as! Bool?).to(equal(false))
    }
    
    func testShouldCreateAnActivityWithMissingData() {
        let client = MockHTTPClient(respondWithJSON: ACTIVITY_JSON)
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<Activity>?
        api.createActivity(withName: "Rowing session", withType: .rowing, withStartDate: Date(day: 20, month: 1, year: 2016, hour: 12, minute: 35, second: 46), withElapsedTime: Time(seconds: 6345)).execute { result = $0 }
        
        expect(result).toEventually(beSuccessful())
        expect(client.lastUrl).to(contain("activities"))
        expect(client.postCalled).to(equal(true))
        expect(client.lastParameters["name"] as! String?).to(equal("Rowing session"))
        expect(client.lastParameters["type"] as! String?).to(equal("Rowing"))
        expect(client.lastParameters["start_date_local"] as! String?).to(equal("2016-01-20T12:35:46Z"))
        expect(client.lastParameters["elapsed_time"] as! Int?).to(equal(6345))
        expect(client.lastParameters["description"] as! String?).to(beNil())
        expect(client.lastParameters["distance"] as! Double?).to(beNil())
        expect(client.lastParameters["private"] as! Bool?).to(beNil())
        expect(client.lastParameters["trainer"] as! Bool?).to(beNil())
        expect(client.lastParameters["commute"] as! Bool?).to(beNil())
    }
    
    func testShouldRetrieveActivity() {
        let client = MockHTTPClient(respondWithJSON: ACTIVITY_JSON)
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<Activity>?
        api.retrieveActivity(withID: 321934, includeAllEfforts: true).execute{ result = $0 }
        
        expect(result).toEventually(beSuccessful())
        expect(client.lastUrl).to(contain("activities/321934"))
        expect(client.getCalled).to(equal(true))
        expect(client.lastParameters["include_all_efforts"] as! Bool?).to(equal(true))
    }
    
    func testShouldUpdateActivity() {
        let client = MockHTTPClient(respondWithJSON: ACTIVITY_JSON)
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<Activity>?
        api.updateActivity(withID: 321934, withName: "Rowing session", withType: .rowing, isPrivate: true, withTrainer: false, withCommute: true, withGearID: "b123456", withDescription: "Best training ever!").execute{ result = $0 }
        
        expect(result).toEventually(beSuccessful())
        expect(client.lastUrl).to(contain("activities/321934"))
        expect(client.putCalled).to(equal(true))
        expect(client.lastParameters["name"] as! String?).to(equal("Rowing session"))
        expect(client.lastParameters["type"] as! String?).to(equal("Rowing"))
        expect(client.lastParameters["private"] as! Bool?).to(equal(true))
        expect(client.lastParameters["trainer"] as! Bool?).to(equal(false))
        expect(client.lastParameters["commute"] as! Bool?).to(equal(true))
        expect(client.lastParameters["gear_id"] as! String?).to(equal("b123456"))
        expect(client.lastParameters["description"] as! String?).to(equal("Best training ever!"))
    }
    
    func testShouldDeleteAnActivity() {
        let client = MockHTTPClient(respondWithJSON: "")
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<Bool>?
        api.deleteActivity(withID: 321934).execute{ result = $0 }
        
        expect(result).to(beSuccessful())
        expect(client.lastUrl).to(contain("activities/321934"))
        expect(client.deleteCalled).to(equal(true))
    }
    
    func testShouldListActivities() {
        let client = MockHTTPClient(respondWithJSON: "[]")
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<EquatableArray<Activity>>?
        api.listActivities(before: 1000, after: 2000).of(page: 2, itemsPerPage: 10).execute{ result = $0 }
        
        expect(result).to(beSuccessful())
        expect(client.lastUrl).to(contain("activities"))
        expect(client.getCalled).to(equal(true))
        expect(client.lastParameters["before"] as! Int?).to(equal(1000))
        expect(client.lastParameters["after"] as! Int?).to(equal(2000))
        expect(client.lastParameters["page"] as! Int?).to(equal(2))
        expect(client.lastParameters["per_page"] as! Int?).to(equal(10))
    }
    
    func testShouldListFriendsActivities() {
        let client = MockHTTPClient(respondWithJSON: "[]")
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<EquatableArray<Activity>>?
        api.listFriendsActivities(before: 1000).of(page: 2, itemsPerPage: 10).execute{ result = $0 }
        
        expect(result).to(beSuccessful())
        expect(client.lastUrl).to(contain("activities/following"))
        expect(client.getCalled).to(equal(true))
        expect(client.lastParameters["before"] as! Int?).to(equal(1000))
        expect(client.lastParameters["page"] as! Int?).to(equal(2))
        expect(client.lastParameters["per_page"] as! Int?).to(equal(10))
    }
    
    func testShouldListRelatedActivities() {
        let client = MockHTTPClient(respondWithJSON: "[]")
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<EquatableArray<Activity>>?
        api.listRelatedActivities(toActivityWithID: 321934).of(page: 2, itemsPerPage: 10).execute{ result = $0 }
        
        expect(result).to(beSuccessful())
        expect(client.lastUrl).to(contain("activities/321934/related"))
        expect(client.getCalled).to(equal(true))
        expect(client.lastParameters["page"] as! Int?).to(equal(2))
        expect(client.lastParameters["per_page"] as! Int?).to(equal(10))
    }
    
    func testShouldListActivityZones() {
        let client = MockHTTPClient(respondWithJSON: ACTIVITY_ZONES_JSON)
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<EquatableArray<ActivityZone>>?
        api.listActivityZones(withID: 321934).execute{ result = $0 }
        
        expect(result).toEventually(beSuccessful())
        expect(client.lastUrl).to(contain("activities/321934/zones"))
        expect(client.getCalled).to(equal(true))
    }
    
    func testShouldListActivityLaps() {
        let client = MockHTTPClient(respondWithJSON: ACTIVITY_LAPS_JSON)
        let api = ActivityAPI(client: client)
        
        var result : StravaResult<EquatableArray<ActivityLap>>?
        api.listActivityLaps(withID: 321934).execute{ result = $0 }
        
        expect(result).toEventually(beSuccessful())
        expect(client.lastUrl).to(contain("activities/321934/laps"))
        expect(client.getCalled).to(equal(true))
    }
    
    let ACTIVITY_JSON = "{" +
        "  \"id\": 321934," +
        "  \"resource_state\": 3," +
        "  \"external_id\": \"2012-12-12_21-40-32-80-29011.fit\"," +
        "  \"upload_id\": 361720," +
        "  \"athlete\": {" +
        "    \"id\": 227615," +
        "    \"resource_state\": 1" +
        "  }," +
        "  \"name\": \"Evening Ride\"," +
        "  \"description\": \"the best ride ever\"," +
        "  \"distance\": 4475.4," +
        "  \"moving_time\": 1303," +
        "  \"elapsed_time\": 1333," +
        "  \"total_elevation_gain\": 154.5," +
        "  \"elev_high\": 331.4," +
        "  \"elev_low\": 276.1," +
        "  \"type\": \"Run\"," +
        "  \"start_date\": \"2012-12-13T03:43:19Z\"," +
        "  \"start_date_local\": \"2012-12-12T19:43:19Z\"," +
        "  \"timezone\": \"(GMT-08:00) America/Los_Angeles\"," +
        "  \"start_latlng\": [" +
        "    37.8," +
        "    -122.27" +
        "  ]," +
        "  \"end_latlng\": [" +
        "    37.8," +
        "    -122.27" +
        "  ]," +
        "  \"achievement_count\": 6," +
        "  \"kudos_count\": 1," +
        "  \"comment_count\": 1," +
        "  \"athlete_count\": 1," +
        "  \"photo_count\": 0," +
        "  \"total_photo_count\": 0," +
        "  \"photos\": {" +
        "    \"count\": 2," +
        "    \"primary\": {" +
        "      \"id\": null," +
        "      \"source\": 1," +
        "      \"unique_id\": \"d64643ec9205\"," +
        "      \"urls\": {" +
        "        \"100\": \"http://pics.com/28b9d28f-128x71.jpg\"," +
        "        \"600\": \"http://pics.com/28b9d28f-768x431.jpg\"" +
        "      }" +
        "    }" +
        "  }," +
        "  \"map\": {" +
        "    \"id\": \"a32193479\"," +
        "    \"polyline\": \"kiteFpCBCD]\"," +
        "    \"summary_polyline\": \"{cteFjcaBkCx@gEz@\"," +
        "    \"resource_state\": 3" +
        "  }," +
        "  \"trainer\": false," +
        "  \"commute\": false," +
        "  \"manual\": false," +
        "  \"private\": false," +
        "  \"flagged\": false," +
        "  \"workout_type\": 2," +
        "  \"gear\": {" +
        "    \"id\": \"g138727\"," +
        "    \"primary\": true," +
        "    \"name\": \"Nike Air\"," +
        "    \"distance\": 88983.1," +
        "    \"resource_state\": 2" +
        "  }," +
        "  \"average_speed\": 3.4," +
        "  \"max_speed\": 4.514," +
        "  \"calories\": 390.5," +
        "  \"has_kudoed\": false," +
        "  \"segment_efforts\": [" +
        "    {" +
        "      \"id\": 543755075," +
        "      \"resource_state\": 2," +
        "      \"name\": \"Dash for the Ferry\"," +
        "      \"segment\": {" +
        "        \"id\": 2417854," +
        "        \"resource_state\": 2," +
        "        \"name\": \"Dash for the Ferry\"," +
        "        \"activity_type\": \"Run\"," +
        "        \"distance\": 1055.11," +
        "        \"average_grade\": -0.1," +
        "        \"maximum_grade\": 2.7," +
        "        \"elevation_high\": 4.7," +
        "        \"elevation_low\": 2.7," +
        "        \"start_latlng\": [" +
        "          37.7905785," +
        "          -122.27015622" +
        "        ]," +
        "        \"end_latlng\": [" +
        "          37.79536649," +
        "          -122.2796434" +
        "        ]," +
        "        \"climb_category\": 0," +
        "        \"city\": \"Oakland\"," +
        "        \"state\": \"CA\"," +
        "        \"country\": \"United States\"," +
        "        \"private\": false" +
        "      }," +
        "      \"activity\": {" +
        "        \"id\": 32193479," +
        "        \"resource_state\": 1" +
        "      }," +
        "      \"athlete\": {" +
        "        \"id\": 3776," +
        "        \"resource_state\": 1" +
        "      }," +
        "      \"kom_rank\": 2," +
        "      \"pr_rank\": 1," +
        "      \"elapsed_time\": 304," +
        "      \"moving_time\": 304," +
        "      \"start_date\": \"2012-12-13T03:48:14Z\"," +
        "      \"start_date_local\": \"2012-12-12T19:48:14Z\"," +
        "      \"distance\": 1052.33," +
        "      \"start_index\": 5348," +
        "      \"end_index\": 6485," +
        "      \"hidden\": false," +
        "      \"achievements\": [" +
        "        {" +
        "          \"type_id\": 2," +
        "          \"type\": \"overall\"," +
        "          \"rank\": 2" +
        "        }," +
        "        {" +
        "          \"type_id\": 3," +
        "          \"type\": \"pr\"," +
        "          \"rank\": 1" +
        "        }" +
        "      ]" +
        "    }" +
        "  ]," +
        "  \"splits_metric\": [" +
        "    {" +
        "      \"distance\": 1002.5," +
        "      \"elapsed_time\": 276," +
        "      \"elevation_difference\": 0," +
        "      \"moving_time\": 276," +
        "      \"split\": 1" +
        "    }," +
        "    {" +
        "      \"distance\": 475.7," +
        "      \"elapsed_time\": 139," +
        "      \"elevation_difference\": 0," +
        "      \"moving_time\": 139," +
        "      \"split\": 5" +
        "    }" +
        "  ]," +
        "  \"splits_standard\": [" +
        "    {" +
        "      \"distance\": 1255.9," +
        "      \"elapsed_time\": 382," +
        "      \"elevation_difference\": 3.2," +
        "      \"moving_time\": 382," +
        "      \"split\": 3" +
        "    }" +
        "  ]," +
        "  \"best_efforts\": [" +
        "    {" +
        "      \"id\": 273063933," +
        "      \"resource_state\": 2," +
        "      \"name\": \"400m\"," +
        "      \"activity\": {" +
        "        \"id\": 32193479" +
        "      }," +
        "      \"athlete\": {" +
        "        \"id\": 3776" +
        "      }," +
        "      \"kom_rank\": null," +
        "      \"pr_rank\": null," +
        "      \"elapsed_time\": 105," +
        "      \"moving_time\": 106," +
        "      \"start_date\": \"2012-12-13T03:43:19Z\"," +
        "      \"start_date_local\": \"2012-12-12T19:43:19Z\"," +
        "      \"distance\": 400," +
        "      \"achievements\": [" +
        "      ]" +
        "    }," +
        "    {" +
        "      \"id\": 273063935," +
        "      \"resource_state\": 2," +
        "      \"name\": \"1/2 mile\"," +
        "      \"activity\": {" +
        "        \"id\": 32193479" +
        "      }," +
        "      \"athlete\": {" +
        "        \"id\": 3776" +
        "      }," +
        "      \"kom_rank\": null," +
        "      \"pr_rank\": null," +
        "      \"elapsed_time\": 219," +
        "      \"moving_time\": 220," +
        "      \"start_date\": \"2012-12-13T03:43:19Z\"," +
        "      \"start_date_local\": \"2012-12-12T19:43:19Z\"," +
        "      \"distance\": 805," +
        "      \"achievements\": [" +
        "" +
        "      ]" +
        "    }" +
        "  ]" +
    "}"
    
    let ACTIVITY_ZONES_JSON = "[" +
        "  {" +
        "    \"score\": 215," +
        "    \"distribution_buckets\": [" +
        "      { \"min\": 0,   \"max\":115,  \"time\": 1735 }," +
        "      { \"min\": 115, \"max\": 152, \"time\": 5966 }," +
        "      { \"min\": 152, \"max\": 171, \"time\": 4077 }," +
        "      { \"min\": 171, \"max\": 190, \"time\": 4238 }," +
        "      { \"min\": 190, \"max\": -1,  \"time\": 36 }" +
        "    ]," +
        "    \"type\": \"heartrate\"," +
        "    \"resource_state\": 3," +
        "    \"sensor_based\": true," +
        "    \"points\": 119," +
        "    \"custom_zones\": false," +
        "    \"max\": 196" +
        "  }," +
        "  {" +
        "    \"distribution_buckets\": [" +
        "      { \"min\": 0,   \"max\": 0,   \"time\": 3043 }," +
        "      { \"min\": 0,   \"max\": 50,  \"time\": 999 }," +
        "      { \"min\": 50,  \"max\": 100, \"time\": 489 }," +
        "      { \"min\": 100, \"max\": 150, \"time\": 737 }," +
        "      { \"min\": 150, \"max\": 200, \"time\": 1299 }," +
        "      { \"min\": 200, \"max\": 250, \"time\": 1478 }," +
        "      { \"min\": 250, \"max\": 300, \"time\": 1523 }," +
        "      { \"min\": 300, \"max\": 350, \"time\": 2154 }," +
        "      { \"min\": 350, \"max\": 400, \"time\": 2226 }," +
        "      { \"min\": 400, \"max\": 450, \"time\": 1181 }," +
        "      { \"min\": 450, \"max\": -1,  \"time\": 923 }" +
        "    ]," +
        "    \"type\": \"power\"," +
        "    \"resource_state\": 3," +
        "    \"sensor_based\": true" +
        "  }" +
    "]"
    
    let ACTIVITY_LAPS_JSON = "[" +
        "  {" +
        "    \"id\": 401614652," +
        "    \"resource_state\": 2," +
        "    \"name\": \"Lap 1\"," +
        "    \"activity\": {" +
        "      \"id\": 123" +
        "    }," +
        "    \"athlete\": {" +
        "      \"id\": 227615" +
        "    }," +
        "    \"elapsed_time\": 7092," +
        "    \"moving_time\": 6870," +
        "    \"start_date\": \"2013-11-02T17:39:37Z\"," +
        "    \"start_date_local\": \"2013-11-02T10:39:37Z\"," +
        "    \"distance\": 42121.5," +
        "    \"start_index\": 0," +
        "    \"end_index\": 6826," +
        "    \"total_elevation_gain\": 766.0," +
        "    \"average_speed\": 5.9," +
        "    \"max_speed\": 16.8," +
        "    \"average_cadence\": 64.7," +
        "    \"average_watts\": 156.2," +
        "    \"device_watts\": false," +
        "    \"has_heartrate\": true," +
        "    \"average_heartrate\": 141.1," +
        "    \"max_heartrate\": 176.0," +
        "    \"lap_index\": 1" +
        "  }" +
    "]"
}

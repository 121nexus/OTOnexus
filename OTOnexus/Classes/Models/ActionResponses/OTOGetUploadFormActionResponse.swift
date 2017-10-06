//
//  OTOGetUploadFormActionResponse.swift
//  OTOnexus
//
//  Created by Nicholas Schlueter on 9/28/17.
//

public class OTOGetUploadFormActionResponse: OTOActionResponse {
    var secretAccessKey = ""
    var accessKeyId = ""
    var bucketRegion = ""
    var bucketName = ""
    var key = ""
    var acl = ""
    
    override func decode(_ responseData: ResponseData) {
        super.decode(responseData)
        
        self.bucketName = responseData.stringValue(forKey: "bucket_name")
        self.bucketRegion = responseData.stringValue(forKey: "bucket_region")
        
        let credentials = responseData.responseDataValue(forKey: "credentials")
        self.secretAccessKey = credentials.stringValue(forKey: "secret_access_key")
        self.accessKeyId = credentials.stringValue(forKey: "access_key_id")
        
        let fields = responseData.responseDataValue(forKey: "fields")
        self.key = fields.stringValue(forKey: "key")
        self.acl = fields.stringValue(forKey: "acl")
    }
}

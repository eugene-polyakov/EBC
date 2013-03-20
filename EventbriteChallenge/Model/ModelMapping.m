//
//  ModelMapping.m
//  EventbriteChallenge
//
//  Created by Eugene Polyakov on 3/19/13.
//  Copyright (c) 2013 Eugene Polyakov. All rights reserved.
//

#import "ModelMapping.h"
#import "Model.h"

@implementation ModelMapping

+(RKObjectMapping*)venueMapping {
    RKObjectMapping* venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromDictionary:@{
     @"city": @"city",
     @"name": @"name",
     @"country": @"country",
     @"region": @"region",
     @"longitude": @"longitude",
     @"postal_code": @"postalCode",
     @"address_2": @"address2",
     @"address": @"address",
     @"latitude": @"latitude",
     @"id": @"venueId",
     @"country_code": @"countryCode",
     @"Lat-Long": @"latLong",
     }];
    return venueMapping;
}
+(RKObjectMapping*)ticketMapping {
    RKObjectMapping* ticketMapping = [RKObjectMapping mappingForClass:[Ticket class]];
    [ticketMapping addAttributeMappingsFromDictionary:@{
     @"ticket.description":@"desc",
     @"ticket.end_date":@"endDate",
     @"ticket.min":@"min",
     @"ticket.max":@"max",
     @"ticket.price":@"price",
     @"ticket.visible":@"visible",
     @"ticket.currency":@"currency",
     @"ticket.type":@"type",
     @"ticket.id":@"ticketId",
     @"ticket.name":@"name",
     }];
    return ticketMapping;
}

+(RKObjectMapping*)eventMapping {
    RKObjectMapping* eventMapping = [RKObjectMapping mappingForClass:[Event class]];
    [eventMapping addAttributeMappingsFromDictionary:@{
    @"box_header_text_color":@"boxHeaderTextColor",
    @"link_color":@"linkColor",
    @"box_background_color":@"boxBackgroundColor",
    @"timezone":@"timezone",
    @"box_border_color":@"boxBorderColor",
    @"logo":@"logo",
    @"background_color":@"backgroundColor",
    @"id":@"eventId",
    @"category":@"category",
    @"box_header_background_color":@"boxHeaderBackgroundColor",
    @"capacity":@"capacity",
    @"num_attendee_rows":@"numAttendeeRows",
    @"title":@"title",
    @"start_date":@"startDate",
    @"status":@"status",
    @"description":@"desc",
    @"end_date":@"endDate",
    @"tags":@"tags",
    @"timezone_offset":@"timezoneOffset",
    @"text_color":@"textColor",
    @"title_text_color":@"titleTextColor",
    @"created":@"created",
    @"url":@"url",
    @"box_text_color":@"boxTextColor",
    @"privacy":@"privacy",
    @"modified":@"modified",
    @"logo_ssl":@"logoSsl",
    @"repeats":@"repeats",
     }];
    [eventMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"venue" toKeyPath:@"venue" withMapping:[self venueMapping]]];
    [eventMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"organizer" toKeyPath:@"organizer" withMapping:[self organizerMapping]]];
    RKObjectMapping * ticketMapping = [self ticketMapping];
//    [eventMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"event.tickets" toKeyPath:@"tickets" withMapping:ticketMapping]];
    return eventMapping;
}

+(RKObjectMapping*)organizerMapping {
    RKObjectMapping* organizerMapping = [RKObjectMapping mappingForClass:[Organizer class]];
    [organizerMapping addAttributeMappingsFromDictionary:@{
     @"url":@"url",
     @"description":@"desc",
     @"long_description":@"longDescription",
     @"id":@"organizerId",
     @"name":@"name",
     }];
    return organizerMapping;
}

@end

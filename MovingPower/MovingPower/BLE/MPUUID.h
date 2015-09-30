//
//  MPUUID.h
//  MovingPower
//
//  Created by Marko Markov on 28/09/15.
//  Copyright © 2015 Channel Enterprise (HK) Ltd. All rights reserved.
//

#ifndef MPUUID_h
#define MPUUID_h

#define ADVERTISE_SERVICE_UUID              @"00005500-D102-11E1-9B23-00025B00A5A5" // UUID for discover devices

#pragma mark -----------------
#pragma mark - Serial Service

#define SERIAL_SERVICE_UUID                 @"00005500-D102-11E1-9B23-00025B00A5A5" // Serial Service UUID
#define SERIAL_DATA_TRANSFER_UUID           @"00005501-D102-11E1-9B23-00025B00A5A5" // Serial Data Transfer UUID

#pragma mark -----------------
#pragma mark - Battery Control Service

#define BATTERY_CONTROL_SERVICE_UUID        @"00002016-D102-11E1-9B23-00025B00A5A5" // Battery Control Service UUID

#define BATTERY_CONTROL_DISCHG_USB1_UUID    @"00002013-D102-11E1-9B23-00025B00A5A5" // Battery control discharge usb1 characteristic UUID
/*  Length: 8 bytes  Data format: string   Byte[0 – 3]: voltage  Byte[4 – 7]: Curren
    Example：USB voltage is5.120V and the current from USB is 1.980A
    The string is “51201980” */

#define BATTERY_CONTROL_DISCHG_USB2_UUID    @"00002018-D102-11E1-9B23-00025B00A5A5" //
/*  Length: 8 bytes  Data format: string   Byte[0 – 3]: voltage  Byte[4 – 7]: Current */

#define BATTERY_CONTROL_BAT_CHG_UUID        @"00002014-D102-11E1-9B23-00025B00A5A5" //
/*  Length: 8 bytes  Data format: string   Byte[0 – 3]: voltage  Byte[4 – 7]: Current */

#define BATTERY_CONTROL_QUALITY_UUID        @"00002011-D102-11E1-9B23-00025B00A5A5" //
/*  Length:2 bytes  Data format: uint16   Low byte first
    (This value will be updated after the charging cycle) */

#define FIND_ME_UUID                        @"00002012-D102-11E1-9B23-00025B00A5A5" //
/*  Length:2 bytes  Data format: uint16 write: 0x0000 (Stop this function) , 0x00xx (wake up in xx
    hour)
    (This characteristic could be read and write., The firmware only provide this Characteristic, it
    don’t handle this characteristic yet)
 
    Usage：Step 1: write 0x00 xx hr  (up to 20 hrs)
    Step 2: then press and hold the button to off  SP25.
    Step 3: SP25 will wake up itself in xx hour.
    Step 4: SP25 will reset the value to 0x0000. */

#pragma mark -----------------
#pragma mark - Battery Service

#define BATTERY_SERVICE_UUID                @"180F"
#define BATTERY_LEVEL                       @"2A19"

#pragma mark -----------------
#pragma mark - OTA Service

#define CSR_OTA_UPDATE_SERVICE_UUID         @"00001016-D102-11E1-9B23-00025B00A5A5"

#define CSR_OTA_CURRENT_APP_UUID            @"00001013-D102-11E1-9B23-00025B00A5A5"
#define CSR_OTA_READ_CS_BLOCK_UUID          @"00001018-D102-11E1-9B23-00025B00A5A5"
#define CSR_OTA_DATA_TRANSFER_UUID          @"00001014-D102-11E1-9B23-00025B00A5A5"
#define CSR_OTA_VERSION_UUID                @"00001011-D102-11E1-9B23-00025B00A5A5"

#endif /* MPUUID_h */

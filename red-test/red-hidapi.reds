Red/System []

windows-hidapi: context [
	#define MAX_STRING_WCHARS				00000FFFh
	#define FILE_SHARE_READ                 00000001h  
	#define FILE_SHARE_WRITE                00000002h 
	#define GENERIC_READ                    80000000h
	#define GENERIC_WRITE                   40000000h
	#define FILE_FLAG_OVERLAPPED            40000000h
	#define DIGCF_PRESENT          			00000002h
	#define DIGCF_DEVICEINTERFACE   		00000010h
	#define HIDP_STATUS_SUCCESS      		00110000h
	#define ERROR_IO_PENDING                997
	#define IOCTL_HID_GET_FEATURE			721298
	#define INVALID-HANDLE-VALUE			FFFFFFFFh


	;remian a block for hidapi.h
	#define MIN(x y) (either x > y [y] [x])

	;--extract the short type data from integer!
	#define LOWORD(param) (param and FFFFh << 16 >> 16)   
	#define HIWORD(param) (param >> 16)


	;the hid header files aren't part of the sdk, we have to define
	;all this stuff here. In C'lookup_functions(). the func pointers
	;defined below are set.
	HIDD-ATTRIBUTES: alias struct! [
			Size 			[integer!]
			ID 				[integer!] ;vendorID and productID
			VersionNumber 	[integer!]
	]

	HIDP-CAPS: alias struct! [
			Usage 				[integer!] ;Usage and UsagePage
			ReportByteLength 	[integer!] ;InputReportByteLength and OutputReportByteLength
			pad1  				[integer!]
			pad2  				[integer!]
			pad3  				[integer!]
			pad4  				[integer!]
			pad5  				[integer!]
			pad6  				[integer!]
			pad7  				[integer!]
			pad8  				[integer!]
			pad9  				[integer!]
			pad10  				[integer!]
			pad11  				[integer!]
			pad12  				[integer!]
			pad13  				[integer!]
			pad14  				[integer!]
	]
	;--define struct
	overlapped-struct: alias struct! [
		Internal	 							[integer!]
		InternalHigh 							[integer!]
		Offset		 							[integer!]
		OffsetHight  							[integer!]
		hEvent		 							[integer!]
	]
	hid-device: alias struct! [
		device-handle 			[int-ptr!]
		blocking 				[logic!]
		output-report-length 	[integer!]
		input-report-length 	[integer!]
		last-error-str 			[int-ptr!]
		last-error-num 			[integer!]
		read-pending 			[logic!]
		read-buf 				[c-string!]
		ol        				[overlapped-struct] 
	]
	hid-device-info: alias struct! [
		path 				[c-string!]
		id 					[integer!] ;vendor-id and product-id
		serial-number 		[c-string!]
		manufacturer-string [c-string!]
		product-string 		[c-string!]
		usage 				[integer!] ;usage-page and usage
		release-number		[integer!]
		interface-number	[integer!]
		next				[hid-device-info]
	]
	guid-struct: alias struct! [     ;--size 16
		data1									[integer!]
		data2									[integer!]
		data3									[integer!]
		data4									[integer!]
	]
	dev-info-data: alias struct! [    ;--size: 28
		cbSize									[integer!]
		ClassGuid								[integer!]
		pad1									[integer!]
		pad2									[integer!]
		pad3									[integer!]
		DevInst									[integer!]
		reserved								[integer!]
	]	
	dev-interface-data: alias struct! [  ;--size: 28
		cbSize									[integer!]
		ClassGuid								[integer!]
		pad1									[integer!]
		pad2									[integer!]
		pad3									[integer!]
		Flags									[integer!]
		reserved								[integer!]
	]
	dev-interface-detail: alias struct! [  ;--size: 8
		cbSize									[integer!]
		DevicePath								[c-string!]
	]
	
	#import [
		"hid.dll" stdcall [
			HidD_GetAttributes: "HidD_GetAttributes" [
				device 		[int-ptr!]
				attrib 		[HIDD-ATTRIBUTES] ;have been not defined
				return: 	[logic!]
			]
			HidD_GetSerialNumberString: "HidD_GetSerialNumberString" [
				handle		[int-ptr!]
				buffer 		[c-string!]
				bufferlen 	[integer!]   ;ulong
				return: 	[logic!]
			]
			HidD_GetManufacturerString: "HidD_GetManufacturerString" [
				handle		[int-ptr!]
				buffer 		[c-string!]
				bufferlen 	[integer!]   ;ulong
				return: 	[logic!]
			]
			HidD_GetProductString: "HidD_GetProductString" [
				handle		[int-ptr!]
				buffer 		[c-string!]
				bufferlen 	[integer!]   ;ulong
				return: 	[logic!]
			]
			HidD_SetFeature: "HidD_SetFeature" [
				handle		[int-ptr!]
				data  		[int-ptr!]
				length 		[integer!] ;ulong
				return: 	[logic!]
			]
			HidD_GetFeature: "HidD_GetFeature" [
				handle		[int-ptr!]
				data  		[int-ptr!]
				length 		[integer!] ;ulong
				return: 	[logic!]
			]
			HidD_GetIndexedString: "HidD_GetIndexedString" [
				handle			[int-ptr!]
				string-index	[integer!] ;ulong
				buffer 			[int-ptr!]
				bufferlen 		[integer!] ;ulong
				return: 		[logic!]
			]
			HidD_GetPreparsedData: "HidD_GetPreparsedData" [
				handle 			[int-ptr!]
				preparsed-data 	[int-ptr!]
				return: 		[logic!]
			]
			HidD_FreePreparsedData: "HidD_FreePreparsedData" [
				preparsed-data 	[int-ptr!]
				return: 		[logic!]
			]
			HidP_GetCaps: "HidP_GetCaps" [
				preparsed-data 	[int-ptr!]
				caps 			[HIDP-CAPS] ;need to check
				return: 		[integer!] ;ulong
			]
			HidD_SetNumInputBuffers: "HidD_SetNumInputBuffers" [
				handle			[int-ptr!]
				number-buffers 	[integer!] ;ulong
				return: 		[logic!]
			]
		]

		"kernel32.dll" stdcall [
			CreateEvent: "CreateEventA" [
				lpEventAttributes				[integer!]
				bManualReset					[integer!]
				bInitialState					[integer!]
				lpName							[integer!]
				return:							[integer!]
			]
			CloseHandle: "CloseHandle" [
				hObject							[integer!]
				return: 						[integer!]
			]
			CreateFile: "CreateFileA" [
				lpFileName						[c-string!]
				dwDesiredAccess					[integer!]
				dwShareMode						[integer!]
				lpSecurityAttributes			[integer!]
				dwCreationDisposition			[integer!]
				dwFlagsAndAttributes			[integer!]
				hTemplateFile					[integer!]
				return:							[integer!]
			]
			LocalFree: "LocalFree" [
				hMem							[int-ptr!]
				return:							[int-ptr!]
			]
			WriteFile:	"WriteFile" [
					handle		[integer!]
					buffer		[byte-ptr!]
					bytes		[integer!]
					written		[int-ptr!]
					overlapped	[int-ptr!]
					return:		[logic!]
				]
			GetLastError: "GetLastError" [
			return:							[integer!]
				]
			ResetEvent: "ResetEvent" [
				hEvent 	[integer!]
			]
			ReadFile:	"ReadFile" [
					file		[integer!]
					buffer		[byte-ptr!]
					bytes		[integer!]
					read		[int-ptr!]
					overlapped	[int-ptr!]
					return:		[logic!]   ;integer!
			]
			CancelIo: "CancelIo" [
				 hFile 		[int-ptr!]	
				 return: 	[integer!]
			]
			WaitForSingleObject: "WaitForSingleObject" [
				hHandle                 [integer!]
				dwMilliseconds          [integer!]
				return:                 [integer!]
			]
			DeviceIoControl: "DeviceIoControl" [
				hDevice 		[int-ptr!]
				dwIoControlCode	[integer!]
				lpInBuffer		[byte-ptr!]
				nInBufferSize 	[integer!]
				lpOutBuffer 	[byte-ptr!]
				nOutBufferSize 	[integer!]
				lpBytesReturned [int-ptr!]
				lpOverlapped	[overlapped-struct]
				return: 		[logic!]
			]
			FormatMessage: "FormatMessageW" [
				dwFlags		 					[integer!]
				lpSource	 					[integer!]
				dwMessageId  					[integer!]
				dwLanguageId 					[integer!]
				lpBuffer	 					[c-string!]
				nSize		 					[integer!]
				Arguments	 					[integer!]
				return:		 					[integer!]
		]
			GetOverlappedResult: "GetOverlappedResult" [
				hFile							[int-ptr!]
				lpOverlapped					[overlapped-struct]
				lpNumberOfBytesTransferred		[int-ptr!]
				bWait							[logic!]
				return: 						[logic!]
			]
		]
		"setupapi.dll" stdcall [
			SetupDiGetClassDevs: "SetupDiGetClassDevsA" [
				ClassGuid						[guid-struct]
				Enumerator						[integer!]
				hwndParent						[integer!]
				Flags							[integer!]
				return: 						[integer!]
			]
			SetupDiEnumDeviceInterfaces: "SetupDiEnumDeviceInterfaces" [
				DeviceInfoSet 					[integer!]
				DeviceInfoData					[integer!]
				InterfaceClassGuid				[guid-struct]
				MemberIndex						[integer!]
				DeviceInterfaceData				[dev-interface-data]
				return: 						[logic!]
			]	
			SetupDiGetDeviceInterfaceDetail: "SetupDiGetDeviceInterfaceDetailA" [
				DeviceInfoSet 					[int-ptr!]
				DeviceInterfaceData				[dev-interface-data]
				DeviceInterfaceDetailData		[dev-interface-detail]
				DeviceInterfaceDetailDataSize	[integer!]
				RequiredSize					[int-ptr!]
				DeviceInfoData					[dev-info-data]
				return: 						[logic!]
			]
			SetupDiDestroyDeviceInfoList: "SetupDiDestroyDeviceInfoList" [
				handle							[integer!]
				return: 						[logic!]
			]
			SetupDiEnumDeviceInfo: "SetupDiEnumDeviceInfo" [
				DeviceInfoSet 					[integer!]
				MemberIndex						[integer!]
				DeviceInfoData					[dev-info-data]
				return: 						[logic!]
			]
			SetupDiGetDeviceRegistryPropertyA: "SetupDiGetDeviceRegistryPropertyA" [
				DeviceInfoSet 					[integer!]
				DeviceInfoData 					[dev-info-data]
				Property						[integer!]
				PropertyRegDataType				[int-ptr!]
				PropertyBuffer					[c-string!]
				PropertyBufferSize				[integer!]
				RequiredSize					[int-ptr!]
				return: 						[logic!]
		]
		]
		

		LIBC-file cdecl [
			wcsdup: "_wcsdup" [
				strSource   [byte-ptr!]   ;maybe fault
				return: 	[c-string!]
			]
			wcscmp: "wcscmp" [
				string1		[c-string!]
				string2 	[c-string!]
				return: 	[integer!]
			]
			strstr: "strstr" [
				str			[c-string!]
				substr		[c-string!]
				return:		[c-string!]
			]
			strtol: "strtol" [
				Result 		[c-string!]
				String 		[c-string!]
				return: 	[integer!]
			]
			strcmp: "strcmp" [
				Str1 		[c-string!]
				Str2 		[c-string!]
				return: 	[integer!]
			]
			strncpy: "strncpy" [
				target 			[c-string!]
				source 			[c-string!]
				count 			[integer!]
				return: 		[c-string!]
			]
		]
	]

	

	;init hid-device 
	new-hid-device: func [
		return:  	[hid-device]
		/local 
			dev 	[hid-device]
	][
		dev: as hid-device allocate size? hid-device
		dev/device-handle: as int-ptr! INVALID-HANDLE-VALUE
		dev/blocking: true
		dev/output-report-length: 0
		dev/input-report-length: 0
		dev/last-error-str: null
		dev/last-error-num: 0
		dev/read-pending: false
		dev/read-buf: null
		set-memory as byte-ptr! dev/ol null-byte size? dev/ol
		dev/ol/hEvent: CreateEvent null 0 0 null
		return dev
	]

	;--free-hid-device function
	free-hid-device: func [
		dev [hid-device]
	][
		CloseHandle dev/ol/hEvent
		CloseHandle (as integer! dev/device-handle)
		LocalFree 	 dev/last-error-str
		free as byte-ptr! dev/read-buf
		free as byte-ptr! dev
	]

	;--register_error
	register-error: func [
		device 		[hid-device]
		op 			[c-string!]
		/local
			ptr 	[c-string!]
			msg 	[c-string!]
	][
		msg: declare c-string!
		FormatMessage 4864 null GetLastError 1024 msg 0 null
		;--get rid of the CR and LF that FormatMessage() sticks at the
	   	;--end of the message.
		ptr: msg 
		while [ptr/1 <> null-byte] [
			if ptr/1 = #"^(0D)"  [
				ptr/1: null-byte
				break
			]
			ptr: ptr + 1
		]
		;------
		LocalFree device/last-error-str
		device/last-error-str: as int-ptr! msg ;--maybe a fault 

	]

	;--static handle open_device func
	open-device: func [
		path 		[c-string!]
		enumerate 	[logic!]
		return: 	[int-ptr!]
		/local 
			handle 			[int-ptr!]
			desired-access 	[integer!]
			share-mode		[integer!]
	][
		handle: declare int-ptr!
		either enumerate [
			desired-access: 0
		][
			desired-access: GENERIC_WRITE or GENERIC_READ
		]
		
		share-mode: FILE_SHARE_READ or FILE_SHARE_WRITE
		handle: as int-ptr! (CreateFile path desired-access 
		share-mode null 3 FILE_FLAG_OVERLAPPED 0)
		return handle
	]

	;--hid_enumerate function
	hid-enumerate: func [
		id 		[integer!] ;vendor-id and product-id
		return: [hid-device-info]
		/local 
			res 				[logic!]
			root				[hid-device-info]
			cur-dev 			[hid-device-info]
			devinterface-data 	[dev-interface-data value]
			devinterface-detail	[dev-interface-detail] 
			devinfo-data 		[dev-info-data value]
			device-info-set		[int-ptr!]
			InterfaceClassGuid  [guid-struct value]
			device-index		[integer!]
			i					[integer!]
			write-handle 		[int-ptr!]
			required-size 		[integer!]
			attrib 				[HIDD-ATTRIBUTES]
			str 				[c-string!]
			tmp 				[hid-device-info]
			pp-data 			[int-ptr!]
			caps 				[HIDP-CAPS value]
			res1				[logic!]
			nt-res				[integer!]
			wstr				[c-string!]
			len 				[integer!]
			b 					[int-ptr!]
			interface-component [c-string!]
			endptr 				[c-string!]
			hex-str				[c-string!]
			driver_name 		[c-string!]
			buffer 				[c-string!]
			d 					[c-string!]
	][	
		
		root: as hid-device-info allocate size? hid-device-info
		cur-dev: as hid-device-info allocate size? hid-device-info
		;-- allocate mem for devinfo
		root: null
		cur-dev: null
		devinterface-detail: null
		;--Windows objects for interacting with the driver.
		;init InterfaceClassGuid
		InterfaceClassGuid/data1: 4D1E55B2h
		InterfaceClassGuid/data2: 11CFF16Fh
		InterfaceClassGuid/data3: 1100CB88h
		InterfaceClassGuid/data4: 30000011h
		;-----------
		device-info-set: as int-ptr! INVALID-HANDLE-VALUE
		device-index: 0

		;--Initialize the Windows objects.
		set-memory as byte-ptr! devinfo-data null-byte size? devinfo-data
		devinfo-data/cbSize: size? dev-info-data
		devinterface-data/cbSize: size? dev-interface-data
		;--information for all the devices belonging to the HID class.
		device-info-set: as int-ptr! SetupDiGetClassDevs InterfaceClassGuid null null 
		(DIGCF_PRESENT or DIGCF_DEVICEINTERFACE)
		;--Iterate over each device in the HID class, looking for the right one.
		forever [
			write-handle: as int-ptr! INVALID-HANDLE-VALUE
			required-size: 0
			attrib: as HIDD-ATTRIBUTES allocate size? HIDD-ATTRIBUTES
			res: SetupDiEnumDeviceInterfaces (as integer! device-info-set) 
			null InterfaceClassGuid device-index devinterface-data 
			if res = false [
				;-- A return of FALSE from this function means that there are no more devices.
				break
			]
			res: SetupDiGetDeviceInterfaceDetail  device-info-set 
			devinterface-data null 0 :required-size null
			devinterface-detail: as dev-interface-detail allocate required-size
			devinterface-detail/cbSize: 5
			;--Get the detailed data for this device.
			res: SetupDiGetDeviceInterfaceDetail  device-info-set 
			devinterface-data devinterface-detail required-size null null ;have some mistakes
			buffer: as c-string! :devinterface-detail/DevicePath
			if res = false [
				free as byte-ptr! devinterface-detail
				device-index: device-index + 1
			]
			;--Make sure this device is of Setup Class "HIDClass" and has a driver bound to it.
			i: 0
			forever [
				driver_name: as c-string! system/stack/allocate 64

				res: SetupDiEnumDeviceInfo (as integer! device-info-set) i devinfo-data 
				if res = false [
					free as byte-ptr! devinterface-detail
					device-index: device-index + 1	
				]

				res: SetupDiGetDeviceRegistryPropertyA (as integer! device-info-set)
				devinfo-data 7 null driver_name 256 null
				if res = false [
					free as byte-ptr! devinterface-detail
					device-index: device-index + 1	
				]

				if (strcmp driver_name "HIDClass") = 0 [
					res: SetupDiGetDeviceRegistryPropertyA (as integer! device-info-set)
					devinfo-data 9 null driver_name 256 null
					if res [
						break
					]
				]
				i: i + 1
			]

			;------------------------
			;--open a handle to the device 
			write-handle: open-device buffer true
			;--check validity of write-handle
			if write-handle = (as int-ptr! INVALID-HANDLE-VALUE) [
				CloseHandle (as integer! write-handle)
			]

			;--Get the Vendor ID and Product ID for this device.
			attrib/Size: size? HIDD-ATTRIBUTES
			probe ["attrib/Size:" attrib/Size]
			HidD_GetAttributes write-handle attrib
			if (id = 0) or (attrib/ID = id) [
				probe "hello"
				wstr: as c-string! system/stack/allocate 256
				
				tmp: as hid-device-info system/stack/allocate (size? hid-device-info) / 4
				pp-data: declare int-ptr!
				d: declare c-string!
				;pp-data: null
				;--vid/pid match . create the record
				either as logic! cur-dev [
					cur-dev/next: tmp
				][
					root: tmp
				]
				cur-dev: tmp
				probe "hi"
				;--Get the Usage Page and Usage for this device.
				res1: HidD_GetPreparsedData write-handle pp-data 
				if res1 [
					nt-res: HidP_GetCaps (as int-ptr! pp-data/value) caps
					probe "hello2"
					probe nt-res 
					if nt-res = 00110000h [
						cur-dev/usage: caps/Usage
					]
					HidD_FreePreparsedData as int-ptr! pp-data/value
					HidD_FreePreparsedData pp-data
					probe "hello3"
				]
				;--fill out the record
				cur-dev/next: null
				str: buffer
				either as logic! (as integer! str) [
					;len: length? str
					len: length? str

					cur-dev/path: as c-string! allocate (len + 1)
					strncpy cur-dev/path str (len + 1)
					probe str
					;cur-dev/path/(len + 1): null-byte ???
					
				][
					cur-dev/path: null
					
				]
				;--define wstr 
				;wstr: as int-ptr! system/stack/allocate 256
 
				;--serial number
				probe "hello4"
				res1: HidD_GetSerialNumberString write-handle wstr 1024
				;b/value: b/value and 0000FFFFh or (00000000h << 16)
				wstr/1021: null-byte
				wstr/1022: null-byte
				probe ["res1:" res1 ]
				if res1 [
					cur-dev/serial-number: wcsdup (as byte-ptr! wstr)
				]
				;--manufacturer string
				res1: HidD_GetManufacturerString write-handle  wstr 1024
				wstr/1021: null-byte
				wstr/1022: null-byte
				if res1 [
					cur-dev/manufacturer-string: wcsdup as byte-ptr! wstr
				]
				;-------

				;--product string
				res1: HidD_GetProductString write-handle wstr 1024
				wstr/1021: null-byte
				wstr/1022: null-byte
				if res1 [
					cur-dev/product-string: wcsdup (as byte-ptr! wstr)
				]

				;--------

				;--vid/pid
				cur-dev/id: attrib/ID

				;--release Number
				cur-dev/release-number: attrib/VersionNumber
				
				;--Interface Number.
				cur-dev/interface-number: -1
				if as logic! (as integer! cur-dev/path) [
					interface-component: declare c-string!
					interface-component: strstr cur-dev/path "&mi_"
					if as logic! (as integer! interface-component)[
					hex-str: declare c-string!
					endptr: declare c-string!
					hex-str: interface-component + 4
					endptr: null
					cur-dev/interface-number strtol hex-str endptr 16 ;have some problems
					if (as logic! (strcmp endptr hex-str)) = false [
						cur-dev/interface-number: -1
					]
					]
				]
			]
		]
		;close the device information handle
		SetupDiDestroyDeviceInfoList as integer! device-info-set	
		return root
	]

	hid-free-enumeration: func [
		devs 		[hid-device-info]
		/local
			d 		[hid-device-info value]
			next 	[hid-device-info value]
	][
		d: devs 
		while [as logic! d] [
			next: d/next
			free as byte-ptr! d/path
			free as byte-ptr! d/serial-number
			free as byte-ptr! d/manufacturer-string
			free as byte-ptr! d/product-string
			free as byte-ptr! d
			d: next 
		]
	]




	




	

		hid-close: func [
			dev 	[hid-device]
		][
			if dev <> null [
			CancelIo dev/device-handle
			free-hid-device dev
			]
		]

]






		
		








	


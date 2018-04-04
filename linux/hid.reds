Red/System []
#define	_IOC(inout group num len)   (inout | ((len & IOCPARM_MASK) << 16) | ((group) << 8) | (num))
#define HIDIOCSFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ #"H"  0x06  len)
#define HIDIOCGFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ #"H"  0x07  len)

;--usb hid device property names
device_string_names ["manufacturer"  "product"	"serial"]

;--symbolic names for the properties above
#define DEVICE_STRING_MANUFACTURER  0
#define DEVICE_STRING_PRODUCT       1
#define DEVICE_STRING_SERIAL		2
#define DEVICE_STRING_COUNT			3

#import [
	LIBC-file cdecl [
		mbstowcs: "mbstowcs" [
			src 	[c-string!]
			dst 	[c-string!]
			len 	[integer!]
		]
		wcsdup: "wcsdup" [
			s1 		[c-string!]
			return: [c-string!]
		]
		udev_device_get_sysattr_value: "udev_device_get_sysattr_value" [
			dev 	[int-ptr!]
			sysattr [c-string!]
			return: [c-string!]
		]

	]
]

hid_device: alias struct! [
	device_handle 			[integer!]
	blocking 				[integer!]
	uses_numbered_reports	[integer!]
]

new_hid_device: func [
	dev 		[hid_device]
	return: 	[hid_device]
][
	dev: as hid_device allocate size? hid_device
	dev/device_handle: -1
	dev/blocking: 1
	dev/uses_numbered_reports: 0
	dev 
]

utf8_to_wchar_t: func [
	utf8 		[c-string!]
	return: 	[c-string!]
	/local
		ret 	[c-string!]
		wlen 	[integer!]
		a 		[integer!]
][
	ret: null

	if utf8 <> null [
		wlen: mbstowcs null utf8 0 
		if -1 = wlen [
			return wcsdup ""
		]
		ret: allocate (wlen + 1) * 4   ;--sizeof widechar
		mbstowcs ret utf8 (wlen + 1)
		a: wlen + 1
		ret/a: 0
	]
	ret 
]

;--get an atrribute value from a udev_device and return it as wchar_t
;--string the returned string must be freed with free（） when done
copy_udev_string: func [
	dev 		[int-ptr!] ;--udev_device
	udev_name 	[c-string!] 
	return: 	[c-string!]
][
	utf8_to_wchar_t (udev_device_get_sysattr_value dev udev_name)	
]





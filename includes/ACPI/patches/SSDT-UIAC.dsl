// SSDT-UIAC.dsl
//
// For Gigabyte Z390 UD
//
// Note:
// portType=0 seems to indicate normal external USB2 port (as seen in MacBookPro8,1)
// portType=2 seems to indicate "internal device" (as seen in MacBookPro8,1)
// portType=4 is used by MacBookPro8,3 (reason/purpose unknown)
//

DefinitionBlock ("", "SSDT", 2, "hack", "_UIAC", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            "8086_a36d", Package()
            {
                "port-count", Buffer() { 26, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package() // HS USB3 rear left middle
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() // HS USB3 rear right middle
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // HS USB3 rear left bottom (only registers as USB3 in MacOS)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package() // HS USB3 rear right bottom (only registers as USB3 in MacOS)
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS05", Package() // HS USB3 rear left top
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HS06", Package() // HS USB3 rear right top
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package() // HS USB3 front left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "HS08", Package() // HS USB3 front right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                    "HS12", Package() // MB USB2 Header for Wifi/Bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    "SS01", Package() // SS USB3 rear left middle
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    "SS02", Package() // SS USB3 rear right middle
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 18, 0, 0, 0 },
                    },
                    "SS05", Package() // SS USB rear left top
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 21, 0, 0, 0 },
                    },
                    "SS06", Package() // SS USB rear right top
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 22, 0, 0, 0 },
                    },
                    "SS07", Package() // SS USB front left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 23, 0, 0, 0 },
                    },
                    "SS08", Package() // SS USB front right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 24, 0, 0, 0 },
                    },
                },
            },
        })
    }
}
//EOF

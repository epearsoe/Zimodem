/*
   Copyright 2016-2019 Bo Zimmerman

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

	   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

const int MAX_COMMAND_SIZE=256;
#define ZI_STATE_MACHINE_LEN 7
#define DEFAULT_TERMTYPE "Zimodem"

enum ZResult
{
  ZOK,
  ZERROR,
  ZCONNECT,
  ZNOCARRIER,
  ZIGNORE,
  ZIGNORE_SPECIAL
};

enum ConfigOptions
{
  CFG_WIFISSI=0,
  CFG_WIFIPW=1,
  CFG_BAUDRATE=2,
  CFG_EOLN=3,
  CFG_FLOWCONTROL=4,
  CFG_ECHO=5,
  CFG_RESP_SUPP=6,
  CFG_RESP_NUM=7,
  CFG_RESP_LONG=8,
  CFG_PETSCIIMODE=9,
  CFG_DCDMODE=10,
  CFG_UART=11,
  CFG_CTSMODE=12,
  CFG_RTSMODE=13,
  CFG_DCDPIN=14,
  CFG_CTSPIN=15,
  CFG_RTSPIN=16,
  CFG_S0_RINGS=17,
  CFG_S41_STREAM=18,
  CFG_S60_LISTEN=19,
  CFG_RIMODE=20,
  CFG_DTRMODE=21,
  CFG_DSRMODE=22,
  CFG_RIPIN=23,
  CFG_DTRPIN=24,
  CFG_DSRPIN=25,
  CFG_TIMEZONE=26,
  CFG_TIMEFMT=27,
  CFG_TIMEURL=28,
  CFG_HOSTNAME=29,
  CFG_PRINTDELAYMS=30,
  CFG_PRINTSPEC=31,
  CFG_TERMTYPE=32,
  CFG_LAST=32
};

enum BinType
{
  BTYPE_NORMAL=0,
  BTYPE_HEX=1,
  BTYPE_DEC=2,
  BTYPE_INVALID=3
};

class ZCommand : public ZMode
{
  friend class WiFiClientNode;
  friend class ZConfig;
  friend class ZBrowser;

  private:
    char CRLF[4];
    char LFCR[4];
    char LF[2];
    char CR[2];
    char BS=8;
    char ringCounter = 1;

    ZSerial serial;
    bool packetXOn = true;
    BinType binType = BTYPE_NORMAL;
    uint8_t nbuf[MAX_COMMAND_SIZE];
    char hbuf[MAX_COMMAND_SIZE];
    int eon=0;
    int lastServerClientId = 0;
    WiFiClientNode *current = null;
    bool autoStreamMode=false;
    bool preserveListeners=false;
    unsigned long lastNonPlusTimeMs = 0;
    unsigned long currentExpiresTimeMs = 0;
    char *tempDelimiters = NULL;
    char *tempMaskOuts = NULL;
    char *tempStateMachine = NULL;
    char *delimiters = NULL;
    char *maskOuts = NULL;
    char *stateMachine = NULL;
    char *machineState = NULL;
    String machineQue = "";
    String previousCommand = "";
    WiFiClientNode *nextConn=null;
    int lastPacketId = -1;

    byte CRC8(const byte *data, byte len);

    void showInitMessage();
    bool readSerialStream();
    bool clearPlusProgress();
    bool checkPlusEscape();
    String getNextSerialCommand();
    ZResult doSerialCommand();
    void setConfigDefaults();
    void parseConfigOptions(String configArguments[]);
    void setOptionsFromSavedConfig(String configArguments[]);
    void reSaveConfig();
    void reSendLastPacket(WiFiClientNode *conn);
    void acceptNewConnection();
    void headerOut(const int channel, const int sz, const int crc8);
    void sendConnectionNotice(int nodeId);
    void sendNextPacket();
    void connectionArgs(WiFiClientNode *c);
    uint8_t *doStateMachine(uint8_t *buf, int *bufLen, char **machineState, String *machineQue, char *stateMachine);
    uint8_t *doMaskOuts(uint8_t *buf, int *bufLen, char *maskOuts);
    ZResult doWebDump(const char *filename, const bool cache);

    ZResult doResetCommand();
    ZResult doNoListenCommand();
    ZResult doBaudCommand(int vval, uint8_t *vbuf, int vlen);
    ZResult doTransmitCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber, const char *dmodifiers, int *crc8);
    ZResult doLastPacket(int vval, uint8_t *vbuf, int vlen, bool isNumber);
    ZResult doConnectCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber, const char *dmodifiers);
    ZResult doWiFiCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber, const char *dmodifiers);
    ZResult doDialStreamCommand(unsigned long vval, uint8_t *vbuf, int vlen, bool isNumber, const char *dmodifiers);
    ZResult doPhonebookCommand(unsigned long vval, uint8_t *vbuf, int vlen, bool isNumber, const char *dmodifiers);
    ZResult doAnswerCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber, const char *dmodifiers);
    ZResult doHangupCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber);
    ZResult doEOLNCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber);
    ZResult doInfoCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber);
    ZResult doWebStream(int vval, uint8_t *vbuf, int vlen, bool isNumber, const char *filename, bool cache);
    ZResult doUpdateFirmware(int vval, uint8_t *vbuf, int vlen, bool isNumber);
    ZResult doTimeZoneSetupCommand(int vval, uint8_t *vbuf, int vlen, bool isNumber);

  public:
    int packetSize = 127;
    bool suppressResponses;
    bool numericResponses;
    bool longResponses;
    boolean doEcho;
    String EOLN;
    char EC='+';
    char ECS[32];

    ZCommand();
    void loadConfig();
    FlowControlType getFlowControlType();
    void sendOfficialResponse(ZResult res);
    void serialIncoming();
    void loop();
    void reset();
};



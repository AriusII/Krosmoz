package com.ankamagames.jerakine.utils.misc
{
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class AsyncJPGEncoder
   {
      private const ZigZag:Vector.<int> = Vector.<int>([0,1,5,6,14,15,27,28,2,4,7,13,16,26,29,42,3,8,12,17,25,30,41,43,9,11,18,24,31,40,44,53,10,19,23,32,39,45,52,54,20,22,33,38,46,51,55,60,21,34,37,47,50,56,59,61,35,36,48,49,57,58,62,63]);
      
      private var YTable:Vector.<int> = new Vector.<int>(64,true);
      
      private var UVTable:Vector.<int> = new Vector.<int>(64,true);
      
      private var outputfDCTQuant:Vector.<int> = new Vector.<int>(64,true);
      
      private var fdtbl_Y:Vector.<Number> = new Vector.<Number>(64,true);
      
      private var fdtbl_UV:Vector.<Number> = new Vector.<Number>(64,true);
      
      private var sf:int;
      
      private const aasf:Vector.<Number> = Vector.<Number>([1,1.387039845,1.306562965,1.175875602,1,0.785694958,0.5411961,0.275899379]);
      
      private var YQT:Vector.<int> = Vector.<int>([16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99]);
      
      private const UVQT:Vector.<int> = Vector.<int>([17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99]);
      
      private var YDC_HT:Vector.<BitString>;
      
      private var UVDC_HT:Vector.<BitString>;
      
      private var YAC_HT:Vector.<BitString>;
      
      private var UVAC_HT:Vector.<BitString>;
      
      private var std_dc_luminance_nrcodes:Vector.<int> = Vector.<int>([0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0]);
      
      private var std_dc_luminance_values:Vector.<int> = Vector.<int>([0,1,2,3,4,5,6,7,8,9,10,11]);
      
      private var std_ac_luminance_nrcodes:Vector.<int> = Vector.<int>([0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125]);
      
      private var std_ac_luminance_values:Vector.<int> = Vector.<int>([1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250]);
      
      private var std_dc_chrominance_nrcodes:Vector.<int> = Vector.<int>([0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0]);
      
      private var std_dc_chrominance_values:Vector.<int> = Vector.<int>([0,1,2,3,4,5,6,7,8,9,10,11]);
      
      private var std_ac_chrominance_nrcodes:Vector.<int> = Vector.<int>([0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119]);
      
      private var std_ac_chrominance_values:Vector.<int> = Vector.<int>([0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250]);
      
      private var bitcode:Vector.<BitString> = new Vector.<BitString>(65535,true);
      
      private var category:Vector.<int> = new Vector.<int>(65535,true);
      
      private var byteout:ByteArray;
      
      private var bytenew:int = 0;
      
      private var bytepos:int = 7;
      
      internal var DU:Vector.<int> = new Vector.<int>(64,true);
      
      private var YDU:Vector.<Number> = new Vector.<Number>(64,true);
      
      private var UDU:Vector.<Number> = new Vector.<Number>(64,true);
      
      private var VDU:Vector.<Number> = new Vector.<Number>(64,true);
      
      private var _width:int;
      
      private var _height:int;
      
      private var _DCY:Number;
      
      private var _DCU:Number;
      
      private var _DCV:Number;
      
      private var _ypos:int;
      
      private var _xpos:int;
      
      private var _image:BitmapData;
      
      private var _callBack:Function;
      
      private var _param:Object;
      
      private var _lastFrame:int;
      
      private var _maxTime:int;
      
      public function AsyncJPGEncoder(param1:int = 50)
      {
         super();
         if(param1 <= 0)
         {
            param1 = 1;
         }
         if(param1 > 100)
         {
            param1 = 100;
         }
         this.sf = param1 < 50 ? int(5000 / param1) : int(200 - (param1 << 1));
         this.init();
      }
      
      private function initQuantTables(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 64)
         {
            _loc6_ = int((this.YQT[_loc2_] * param1 + 50) * 0.01);
            if(_loc6_ < 1)
            {
               _loc6_ = 1;
            }
            else if(_loc6_ > 255)
            {
               _loc6_ = 255;
            }
            this.YTable[this.ZigZag[_loc2_]] = _loc6_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 64)
         {
            _loc7_ = int((this.UVQT[_loc2_] * param1 + 50) * 0.01);
            if(_loc7_ < 1)
            {
               _loc7_ = 1;
            }
            else if(_loc7_ > 255)
            {
               _loc7_ = 255;
            }
            this.UVTable[this.ZigZag[_loc2_]] = _loc7_;
            _loc2_++;
         }
         _loc2_ = 0;
         var _loc5_:int = 0;
         while(_loc5_ < 8)
         {
            _loc8_ = 0;
            while(_loc8_ < 8)
            {
               this.fdtbl_Y[_loc2_] = 1 / (this.YTable[this.ZigZag[_loc2_]] * this.aasf[_loc5_] * this.aasf[_loc8_] * 8);
               this.fdtbl_UV[_loc2_] = 1 / (this.UVTable[this.ZigZag[_loc2_]] * this.aasf[_loc5_] * this.aasf[_loc8_] * 8);
               _loc2_++;
               _loc8_++;
            }
            _loc5_++;
         }
      }
      
      private function computeHuffmanTbl(param1:Vector.<int>, param2:Vector.<int>) : Vector.<BitString>
      {
         var _loc6_:BitString = null;
         var _loc8_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<BitString> = new Vector.<BitString>(251,true);
         var _loc7_:int = 1;
         while(_loc7_ <= 16)
         {
            _loc8_ = 1;
            while(_loc8_ <= param1[_loc7_])
            {
               _loc5_[param2[_loc4_]] = _loc6_ = new BitString();
               _loc6_.val = _loc3_;
               _loc6_.len = _loc7_;
               _loc4_++;
               _loc3_++;
               _loc8_++;
            }
            _loc3_ <<= 1;
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function initHuffmanTbl() : void
      {
         this.YDC_HT = this.computeHuffmanTbl(this.std_dc_luminance_nrcodes,this.std_dc_luminance_values);
         this.UVDC_HT = this.computeHuffmanTbl(this.std_dc_chrominance_nrcodes,this.std_dc_chrominance_values);
         this.YAC_HT = this.computeHuffmanTbl(this.std_ac_luminance_nrcodes,this.std_ac_luminance_values);
         this.UVAC_HT = this.computeHuffmanTbl(this.std_ac_chrominance_nrcodes,this.std_ac_chrominance_values);
      }
      
      private function initCategoryNumber() : void
      {
         var _loc3_:BitString = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:* = 1;
         var _loc2_:* = 2;
         var _loc6_:int = 1;
         while(_loc6_ <= 15)
         {
            _loc7_ = _loc1_;
            while(_loc7_ < _loc2_)
            {
               _loc5_ = int(32767 + _loc7_);
               this.category[_loc5_] = _loc6_;
               this.bitcode[_loc5_] = _loc3_ = new BitString();
               _loc3_.len = _loc6_;
               _loc3_.val = _loc7_;
               _loc7_++;
            }
            _loc8_ = -(_loc2_ - 1);
            while(_loc8_ <= -_loc1_)
            {
               _loc5_ = int(32767 + _loc8_);
               this.category[_loc5_] = _loc6_;
               this.bitcode[_loc5_] = _loc3_ = new BitString();
               _loc3_.len = _loc6_;
               _loc3_.val = _loc2_ - 1 + _loc8_;
               _loc8_++;
            }
            _loc1_ <<= 1;
            _loc2_ <<= 1;
            _loc6_++;
         }
      }
      
      private function writeBits(param1:BitString) : void
      {
         var _loc2_:int = param1.val;
         var _loc3_:int = param1.len - 1;
         while(_loc3_ >= 0)
         {
            if(_loc2_ & uint(1 << _loc3_))
            {
               this.bytenew |= uint(1 << this.bytepos);
            }
            _loc3_--;
            --this.bytepos;
            if(this.bytepos < 0)
            {
               if(this.bytenew == 255)
               {
                  this.byteout.writeByte(255);
                  this.byteout.writeByte(0);
               }
               else
               {
                  this.byteout.writeByte(this.bytenew);
               }
               this.bytepos = 7;
               this.bytenew = 0;
            }
         }
      }
      
      private function fDCTQuant(param1:Vector.<Number>, param2:Vector.<Number>) : Vector.<int>
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
         var _loc3_:int = 0;
         _loc12_ = 0;
         while(_loc12_ < 8)
         {
            _loc4_ = param1[int(_loc3_)];
            _loc5_ = param1[int(_loc3_ + 1)];
            _loc6_ = param1[int(_loc3_ + 2)];
            _loc7_ = param1[int(_loc3_ + 3)];
            _loc8_ = param1[int(_loc3_ + 4)];
            _loc9_ = param1[int(_loc3_ + 5)];
            _loc10_ = param1[int(_loc3_ + 6)];
            _loc11_ = param1[int(_loc3_ + 7)];
            _loc16_ = _loc4_ + _loc11_;
            _loc17_ = _loc4_ - _loc11_;
            _loc18_ = _loc5_ + _loc10_;
            _loc19_ = _loc5_ - _loc10_;
            _loc20_ = _loc6_ + _loc9_;
            _loc21_ = _loc6_ - _loc9_;
            _loc22_ = _loc7_ + _loc8_;
            _loc23_ = _loc7_ - _loc8_;
            _loc24_ = _loc16_ + _loc22_;
            _loc25_ = _loc16_ - _loc22_;
            _loc26_ = _loc18_ + _loc20_;
            _loc27_ = _loc18_ - _loc20_;
            param1[int(_loc3_)] = _loc24_ + _loc26_;
            param1[int(_loc3_ + 4)] = _loc24_ - _loc26_;
            _loc28_ = (_loc27_ + _loc25_) * 0.707106781;
            param1[int(_loc3_ + 2)] = _loc25_ + _loc28_;
            param1[int(_loc3_ + 6)] = _loc25_ - _loc28_;
            _loc24_ = _loc23_ + _loc21_;
            _loc26_ = _loc21_ + _loc19_;
            _loc27_ = _loc19_ + _loc17_;
            _loc29_ = (_loc24_ - _loc27_) * 0.382683433;
            _loc30_ = 0.5411961 * _loc24_ + _loc29_;
            _loc31_ = 1.306562965 * _loc27_ + _loc29_;
            _loc32_ = _loc26_ * 0.707106781;
            _loc33_ = _loc17_ + _loc32_;
            _loc34_ = _loc17_ - _loc32_;
            param1[int(_loc3_ + 5)] = _loc34_ + _loc30_;
            param1[int(_loc3_ + 3)] = _loc34_ - _loc30_;
            param1[int(_loc3_ + 1)] = _loc33_ + _loc31_;
            param1[int(_loc3_ + 7)] = _loc33_ - _loc31_;
            _loc3_ += 8;
            _loc12_++;
         }
         _loc3_ = 0;
         _loc12_ = 0;
         while(_loc12_ < 8)
         {
            _loc4_ = param1[int(_loc3_)];
            _loc5_ = param1[int(_loc3_ + 8)];
            _loc6_ = param1[int(_loc3_ + 16)];
            _loc7_ = param1[int(_loc3_ + 24)];
            _loc8_ = param1[int(_loc3_ + 32)];
            _loc9_ = param1[int(_loc3_ + 40)];
            _loc10_ = param1[int(_loc3_ + 48)];
            _loc11_ = param1[int(_loc3_ + 56)];
            _loc35_ = _loc4_ + _loc11_;
            _loc36_ = _loc4_ - _loc11_;
            _loc37_ = _loc5_ + _loc10_;
            _loc38_ = _loc5_ - _loc10_;
            _loc39_ = _loc6_ + _loc9_;
            _loc40_ = _loc6_ - _loc9_;
            _loc41_ = _loc7_ + _loc8_;
            _loc42_ = _loc7_ - _loc8_;
            _loc43_ = _loc35_ + _loc41_;
            _loc44_ = _loc35_ - _loc41_;
            _loc45_ = _loc37_ + _loc39_;
            _loc46_ = _loc37_ - _loc39_;
            param1[int(_loc3_)] = _loc43_ + _loc45_;
            param1[int(_loc3_ + 32)] = _loc43_ - _loc45_;
            _loc47_ = (_loc46_ + _loc44_) * 0.707106781;
            param1[int(_loc3_ + 16)] = _loc44_ + _loc47_;
            param1[int(_loc3_ + 48)] = _loc44_ - _loc47_;
            _loc43_ = _loc42_ + _loc40_;
            _loc45_ = _loc40_ + _loc38_;
            _loc46_ = _loc38_ + _loc36_;
            _loc48_ = (_loc43_ - _loc46_) * 0.382683433;
            _loc49_ = 0.5411961 * _loc43_ + _loc48_;
            _loc50_ = 1.306562965 * _loc46_ + _loc48_;
            _loc51_ = _loc45_ * 0.707106781;
            _loc52_ = _loc36_ + _loc51_;
            _loc53_ = _loc36_ - _loc51_;
            param1[int(_loc3_ + 40)] = _loc53_ + _loc49_;
            param1[int(_loc3_ + 24)] = _loc53_ - _loc49_;
            param1[int(_loc3_ + 8)] = _loc52_ + _loc50_;
            param1[int(_loc3_ + 56)] = _loc52_ - _loc50_;
            _loc3_++;
            _loc12_++;
         }
         _loc12_ = 0;
         while(_loc12_ < 64)
         {
            _loc15_ = param1[int(_loc12_)] * param2[int(_loc12_)];
            this.outputfDCTQuant[int(_loc12_)] = _loc15_ > 0 ? int(_loc15_ + 0.5) : int(_loc15_ - 0.5);
            _loc12_++;
         }
         return this.outputfDCTQuant;
      }
      
      private function writeAPP0() : void
      {
         this.byteout.writeShort(65504);
         this.byteout.writeShort(16);
         this.byteout.writeByte(74);
         this.byteout.writeByte(70);
         this.byteout.writeByte(73);
         this.byteout.writeByte(70);
         this.byteout.writeByte(0);
         this.byteout.writeByte(1);
         this.byteout.writeByte(1);
         this.byteout.writeByte(0);
         this.byteout.writeShort(1);
         this.byteout.writeShort(1);
         this.byteout.writeByte(0);
         this.byteout.writeByte(0);
      }
      
      private function writeSOF0(param1:int, param2:int) : void
      {
         this.byteout.writeShort(65472);
         this.byteout.writeShort(17);
         this.byteout.writeByte(8);
         this.byteout.writeShort(param2);
         this.byteout.writeShort(param1);
         this.byteout.writeByte(3);
         this.byteout.writeByte(1);
         this.byteout.writeByte(17);
         this.byteout.writeByte(0);
         this.byteout.writeByte(2);
         this.byteout.writeByte(17);
         this.byteout.writeByte(1);
         this.byteout.writeByte(3);
         this.byteout.writeByte(17);
         this.byteout.writeByte(1);
      }
      
      private function writeDQT() : void
      {
         var _loc1_:int = 0;
         this.byteout.writeShort(65499);
         this.byteout.writeShort(132);
         this.byteout.writeByte(0);
         _loc1_ = 0;
         while(_loc1_ < 64)
         {
            this.byteout.writeByte(this.YTable[_loc1_]);
            _loc1_++;
         }
         this.byteout.writeByte(1);
         _loc1_ = 0;
         while(_loc1_ < 64)
         {
            this.byteout.writeByte(this.UVTable[_loc1_]);
            _loc1_++;
         }
      }
      
      private function writeDHT() : void
      {
         var _loc1_:int = 0;
         this.byteout.writeShort(65476);
         this.byteout.writeShort(418);
         this.byteout.writeByte(0);
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            this.byteout.writeByte(this.std_dc_luminance_nrcodes[int(_loc1_ + 1)]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ <= 11)
         {
            this.byteout.writeByte(this.std_dc_luminance_values[int(_loc1_)]);
            _loc1_++;
         }
         this.byteout.writeByte(16);
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            this.byteout.writeByte(this.std_ac_luminance_nrcodes[int(_loc1_ + 1)]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ <= 161)
         {
            this.byteout.writeByte(this.std_ac_luminance_values[int(_loc1_)]);
            _loc1_++;
         }
         this.byteout.writeByte(1);
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            this.byteout.writeByte(this.std_dc_chrominance_nrcodes[int(_loc1_ + 1)]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ <= 11)
         {
            this.byteout.writeByte(this.std_dc_chrominance_values[int(_loc1_)]);
            _loc1_++;
         }
         this.byteout.writeByte(17);
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            this.byteout.writeByte(this.std_ac_chrominance_nrcodes[int(_loc1_ + 1)]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ <= 161)
         {
            this.byteout.writeByte(this.std_ac_chrominance_values[int(_loc1_)]);
            _loc1_++;
         }
      }
      
      private function writeSOS() : void
      {
         this.byteout.writeShort(65498);
         this.byteout.writeShort(12);
         this.byteout.writeByte(3);
         this.byteout.writeByte(1);
         this.byteout.writeByte(0);
         this.byteout.writeByte(2);
         this.byteout.writeByte(17);
         this.byteout.writeByte(3);
         this.byteout.writeByte(17);
         this.byteout.writeByte(0);
         this.byteout.writeByte(63);
         this.byteout.writeByte(0);
      }
      
      private function processDU(param1:Vector.<Number>, param2:Vector.<Number>, param3:Number, param4:Vector.<BitString>, param5:Vector.<BitString>) : Number
      {
         var _loc8_:int = 0;
         var _loc17_:* = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc6_:BitString = param5[0];
         var _loc7_:BitString = param5[240];
         var _loc12_:Vector.<int> = this.fDCTQuant(param1,param2);
         var _loc13_:int = 0;
         while(_loc13_ < 64)
         {
            this.DU[this.ZigZag[_loc13_]] = _loc12_[_loc13_];
            _loc13_++;
         }
         var _loc14_:int = this.DU[0] - param3;
         param3 = this.DU[0];
         if(_loc14_ == 0)
         {
            this.writeBits(param4[0]);
         }
         else
         {
            _loc8_ = int(32767 + _loc14_);
            this.writeBits(param4[this.category[_loc8_]]);
            this.writeBits(this.bitcode[_loc8_]);
         }
         var _loc15_:int = 63;
         while(_loc15_ > 0 && this.DU[_loc15_] == 0)
         {
            _loc15_--;
         }
         if(_loc15_ == 0)
         {
            this.writeBits(_loc6_);
            return param3;
         }
         var _loc16_:int = 1;
         while(_loc16_ <= _loc15_)
         {
            _loc18_ = _loc16_;
            while(this.DU[_loc16_] == 0 && _loc16_ <= _loc15_)
            {
               _loc16_++;
            }
            _loc19_ = _loc16_ - _loc18_;
            if(_loc19_ >= 16)
            {
               _loc17_ = _loc19_ >> 4;
               _loc20_ = 1;
               while(_loc20_ <= _loc17_)
               {
                  this.writeBits(_loc7_);
                  _loc20_++;
               }
               _loc19_ = int(_loc19_ & 0x0F);
            }
            _loc8_ = int(32767 + this.DU[_loc16_]);
            this.writeBits(param5[int((_loc19_ << 4) + this.category[_loc8_])]);
            this.writeBits(this.bitcode[_loc8_]);
            _loc16_++;
         }
         if(_loc15_ != 63)
         {
            this.writeBits(_loc6_);
         }
         return param3;
      }
      
      private function RGB2YUV(param1:BitmapData, param2:int, param3:int) : void
      {
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < 8)
         {
            _loc7_ = 0;
            while(_loc7_ < 8)
            {
               _loc8_ = param1.getPixel32(param2 + _loc7_,param3 + _loc6_);
               _loc9_ = _loc8_ >> 16 & 0xFF;
               _loc10_ = _loc8_ >> 8 & 0xFF;
               _loc11_ = _loc8_ & 0xFF;
               this.YDU[int(_loc4_)] = 0.299 * _loc9_ + 0.587 * _loc10_ + 0.114 * _loc11_ - 128;
               this.UDU[int(_loc4_)] = -0.16874 * _loc9_ + -0.33126 * _loc10_ + 0.5 * _loc11_;
               this.VDU[int(_loc4_)] = 0.5 * _loc9_ + -0.41869 * _loc10_ + -0.08131 * _loc11_;
               _loc4_++;
               _loc7_++;
            }
            _loc6_++;
         }
      }
      
      private function init() : void
      {
         this.ZigZag.fixed = true;
         this.aasf.fixed = true;
         this.YQT.fixed = true;
         this.UVQT.fixed = true;
         this.std_ac_chrominance_nrcodes.fixed = true;
         this.std_ac_chrominance_values.fixed = true;
         this.std_ac_luminance_nrcodes.fixed = true;
         this.std_ac_luminance_values.fixed = true;
         this.std_dc_chrominance_nrcodes.fixed = true;
         this.std_dc_chrominance_values.fixed = true;
         this.std_dc_luminance_nrcodes.fixed = true;
         this.std_dc_luminance_values.fixed = true;
         this.initHuffmanTbl();
         this.initCategoryNumber();
         this.initQuantTables(this.sf);
      }
      
      private function process(param1:Event) : void
      {
         FpsManager.getInstance().startTracking("processJPG",1243644);
         var _loc2_:int = getTimer();
         while(true)
         {
            this.RGB2YUV(this._image,this._xpos,this._ypos);
            this._DCY = this.processDU(this.YDU,this.fdtbl_Y,this._DCY,this.YDC_HT,this.YAC_HT);
            this._DCU = this.processDU(this.UDU,this.fdtbl_UV,this._DCU,this.UVDC_HT,this.UVAC_HT);
            this._DCV = this.processDU(this.VDU,this.fdtbl_UV,this._DCV,this.UVDC_HT,this.UVAC_HT);
            this._xpos += 8;
            if(this._xpos >= this._width)
            {
               this._xpos = 0;
               this._ypos += 8;
               if(this._ypos >= this._height)
               {
                  break;
               }
            }
            if(getTimer() - _loc2_ > this._maxTime)
            {
               var _loc3_:int = _loc2_ - this._lastFrame;
               this._lastFrame = _loc2_;
               if(_loc3_ > 20)
               {
                  this._maxTime -= 2;
                  if(this._maxTime < 1)
                  {
                     this._maxTime = 1;
                  }
               }
               else
               {
                  ++this._maxTime;
               }
               FpsManager.getInstance().stopTracking("processJPG");
               return;
            }
         }
         EnterFrameDispatcher.removeEventListener(this.process);
         this.endProcess();
      }
      
      public function encode(param1:BitmapData, param2:Function, param3:Object) : void
      {
         EnterFrameDispatcher.addEventListener(this.process,"jpgEncoder");
         this._image = param1;
         this._callBack = param2;
         this._param = param3;
         this._maxTime = 10;
         this.byteout = new ByteArray();
         this.bytenew = 0;
         this.bytepos = 7;
         this.byteout.writeShort(65496);
         this.writeAPP0();
         this.writeDQT();
         this.writeSOF0(param1.width,param1.height);
         this.writeDHT();
         this.writeSOS();
         this._DCY = 0;
         this._DCU = 0;
         this._DCV = 0;
         this.bytenew = 0;
         this.bytepos = 7;
         this._width = param1.width;
         this._height = param1.height;
         this._ypos = 0;
         this._xpos = 0;
      }
      
      private function endProcess() : void
      {
         var _loc1_:BitString = null;
         if(this.bytepos >= 0)
         {
            _loc1_ = new BitString();
            _loc1_.len = this.bytepos + 1;
            _loc1_.val = (1 << this.bytepos + 1) - 1;
            this.writeBits(_loc1_);
         }
         this.byteout.writeShort(65497);
         this._callBack(this.byteout,this._param);
      }
   }
}

final class BitString
{
   public var len:int = 0;
   
   public var val:int = 0;
   
   public function BitString()
   {
      super();
   }
}

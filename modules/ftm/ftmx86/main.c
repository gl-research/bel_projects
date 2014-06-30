#include <unistd.h> /* getopt */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <etherbone.h>
#include "xmlaux.h"
#include "ftmx86.h"



#define MAX_DEVICES  100
#define BUF_SIZE     0x600
#define PACKET_SIZE  500

const char* program;
eb_device_t device;
eb_socket_t mySocket;

const    uint32_t devID_RAM 	      = 0x66cfeb52;
const    uint64_t vendID_CERN       = 0x000000000000ce42;
const    uint32_t devID_ClusterInfo = 0x10040086;
const    uint64_t vendID_GSI        = 0x0000000000000651;
char              devName_RAM_pre[] = "WB4-BlockRAM_";
		
volatile uint32_t embeddedOffset;
uint8_t error, verbose, readonly;
volatile uint8_t cpuQty;


int ebRamOpen(const char* netaddress, uint8_t cpuId);
int ebRamRead(uint32_t address, uint32_t len, const uint8_t* buf);
int ebRamWrite(const uint8_t* buf, uint32_t address, uint32_t len);
int ebRamClose(void);


int ebRamOpen(const char* netaddress, uint8_t cpuId)
{
   
   eb_status_t status;
   int idx;
   int attempts;
   int num_devices;
   struct sdb_device devices[MAX_DEVICES];
   char              devName_RAM_post[4];
   

   attempts   = 3;
   idx        = -1;

   
  
  /* open EB socket and device */
      if ((status = eb_socket_open(EB_ABI_CODE, 0, EB_ADDR32 | EB_DATA32, &mySocket)) != EB_OK) {
    fprintf(stderr, "%s: failed to open Etherbone socket: %s\n", program, eb_status(status));
    return 1;
  }
  if ((status = eb_device_open(mySocket, netaddress, EB_ADDR32 | EB_DATA32, attempts, &device)) != EB_OK) {
    fprintf(stderr, "%s: failed to open Etherbone device: %s\n", program, eb_status(status));
    return 1;
  }


  num_devices = MAX_DEVICES;
  eb_sdb_find_by_identity(device, vendID_GSI, devID_ClusterInfo, &devices[0], &num_devices);
  if (num_devices == 0) {
    fprintf(stderr, "%s: No lm32 clusterId rom found\n", program);
    ebRamClose();
    return 1;
  }

  if (num_devices > MAX_DEVICES) {
    fprintf(stderr, "%s: Way too many lm32 clusterId roms found, something's wrong\n", program);
    return 1;
  }

  if (idx > num_devices) {
    fprintf(stderr, "%s: device #%d could not be found; only %d present\n", program, idx, num_devices);
    return 1;
  }

  if (idx == -1) {
    
    
  } else {
    
    
  }
  //printf("Found Cluster Info @ %08x\n", (uint32_t)devices[0].sdb_component.addr_first);
  //get number of CPUs and create search string
  eb_device_read(device, (uint32_t)devices[0].sdb_component.addr_first, EB_BIG_ENDIAN | EB_DATA32, (eb_data_t*)&cpuQty, 0, eb_block);
  devName_RAM_post[0] = '0';
  devName_RAM_post[1] = '0' + (cpuQty & 0xf);
  devName_RAM_post[2] = '0' + (cpuId & 0xf);
  devName_RAM_post[3] = 0;
  
  
  if(cpuQty <= cpuId)
  {   
      fprintf(stderr, "The CpuId you gave me (%u) is higher than maximum (%u-1).\n", cpuId, cpuQty);
      ebRamClose();
      return 1;
  }
  
  
  if (verbose) printf("\tSearching for RAM of Cpu %u/%u\n", cpuId, (cpuQty & 0xf));
  num_devices = MAX_DEVICES;
  eb_sdb_find_by_identity(device, vendID_CERN, devID_RAM, &devices[0], &num_devices);
  if (num_devices == 0) {
    fprintf(stderr, "%s: no RAM's found\n", program);
    ebRamClose();
    return 1;
  }

  if (num_devices > MAX_DEVICES) {
    fprintf(stderr, "%s: more devices found that tool supports (%d > %d)\n", program, num_devices, MAX_DEVICES);
    return 1;
  }

  if (idx > num_devices) {
    fprintf(stderr, "%s: device #%d could not be found; only %d present\n", program, idx, num_devices);
    return 1;
  }

  if (idx == -1) {
    //printf("Found %u devs\n", num_devices);
    for (idx = 0; idx < num_devices; ++idx) {
      //printf("%.*s 0x%"PRIx64"\n", 19, &devices[idx].sdb_component.product.name[0], devices[idx].sdb_component.addr_first);
         if(strncmp(devName_RAM_post, (const char*)&devices[idx].sdb_component.product.name[13], 3) == 0)
         {
            if (verbose) printf("\tfound %.*s @ 0x%08x\n", 19, &devices[idx].sdb_component.product.name[0], (uint32_t)devices[idx].sdb_component.addr_first);
            embeddedOffset = devices[idx].sdb_component.addr_first;
            return 0;
         }
         
    }
  } else {
    printf("0x%"PRIx64"\n", devices[idx].sdb_component.addr_first);
  }
  
  fprintf(stderr, "Could not find RAM of CPU %u\n", cpuId);
  ebRamClose();
  return 1;
}

int ebRamClose()
{

   eb_status_t status;

      if ((status = eb_device_close(device)) != EB_OK) {
       fprintf(stderr, "%s: failed to close Etherbone device: %s\n", program, eb_status(status));
       return 1;
     }

     if ((status = eb_socket_close(mySocket)) != EB_OK) {
       fprintf(stderr, "%s: failed to close Etherbone socket: %s\n", program, eb_status(status));
       return 1;
     }
     
     return 0;
  
}

int ebRamRead(uint32_t address, uint32_t len, const uint8_t* buf)
{
   
   eb_status_t status;
   eb_cycle_t cycle;
   uint32_t i,j, parts, partLen, start;
   uint32_t* readin = (uint32_t*)buf;	

   //wrap frame buffer in EB packet
   parts = (len/PACKET_SIZE)+1;
   start = 0;
   
   for(j=0; j<parts; j++)
   {
      if(j == parts-1 && (len % PACKET_SIZE != 0)) partLen = len % PACKET_SIZE;
      else partLen = PACKET_SIZE;
      
      if ((status = eb_cycle_open(device, 0, eb_block, &cycle)) != EB_OK) {
            fprintf(stderr, "%s: failed to create cycle: %s\n", program, eb_status(status));
            return 1;
         }  
      //printf("Parts %2u Idx %2u PartLen %4u\n", parts, j, partLen);
      for(i= start>>2; i< (start + partLen) >>2;i++)  
      {
         //printf("%4u %08x -> %p\n", i, (address+(i<<2)), &readin[i]);
         eb_cycle_read(cycle, (eb_address_t)(address+(i<<2)), EB_BIG_ENDIAN | EB_DATA32,  (eb_data_t*)&readin[i]); 
         
      }
      eb_cycle_close(cycle);
      start = start + partLen;
   }   
   return len;
}

int ebRamWrite(const uint8_t* buf, uint32_t address, uint32_t len)
{
   eb_status_t status;
   eb_cycle_t cycle;
   uint32_t i,j, parts, partLen, start;
   uint32_t* writeout = (uint32_t*)buf;	
   
   //wrap frame buffer in EB packet
   parts = (len/PACKET_SIZE)+1;
   start = 0;
   
   for(j=0; j<parts; j++)
   {
      if(j == parts-1 && (len % PACKET_SIZE != 0)) partLen = len % PACKET_SIZE;
      else partLen = PACKET_SIZE;
      
      if ((status = eb_cycle_open(device, 0, eb_block, &cycle)) != EB_OK) {
            fprintf(stderr, "%s: failed to create cycle: %s\n", program, eb_status(status));
            return 1;
         } 
      
       for(i= start>>2; i< (start + partLen) >>2;i++)  
      {
         //printf("%4u %p -> %08x\n", i, &writeout[i], (address+(i<<2)));
         eb_cycle_write(cycle, (eb_address_t)(address+(i<<2)), EB_BIG_ENDIAN | EB_DATA32, writeout[i]); 
      }
      eb_cycle_close(cycle);
      start = start + partLen;
   }
   return len;
}

static void help(void) {
  fprintf(stderr, "\nUsage: %s [OPTION] <etherbone-device> [command]\n", program);
  fprintf(stderr, "\n");
  fprintf(stderr, "  -x <filename>             select xml file with FTM data to copy to ftm cpu\n");
  fprintf(stderr, "  -c <cpu-id>               select a cpu by index#\n");
  fprintf(stderr, "  -v                        verbose operation, print more details\n");
  fprintf(stderr, "  -h                        display this help and exit\n");
  fprintf(stderr, "\n");
  fprintf(stderr, "  status                    (default) report this ftm cpu's status\n");
  fprintf(stderr, "  run                       run this ftm cpu\n");
  fprintf(stderr, "  stop                      request stop on this ftm cpu\n");
  fprintf(stderr, "  fstop                     force stop on this ftm cpu\n");
  fprintf(stderr, "  idle                      request idle state on this ftm cpu\n");
  fprintf(stderr, "  swap                      swap active and inactive ftm data on this ftm cpu\n");
  fprintf(stderr, "  show                      Make this cpu output its data to console\n");
  fprintf(stderr, "  put                       puts ftm data from xml file to cpu, then reads back ftm data from cpu.\n");
  fprintf(stderr, "  get                       gets ftm data from cpu.\n");
  fprintf(stderr, "\n");
}

static void die(eb_status_t status, const char* what) {
  fprintf(stderr, "%s: %s -- %s\n", program, what, eb_status(status));
  exit(1);
}

static void status(uint8_t cpuId)
{
    uint32_t ftmStatus;
    eb_device_read(device, embeddedOffset + FTM_STAT_OFFSET, EB_BIG_ENDIAN | EB_DATA32, (eb_data_t*)&ftmStatus, 0, eb_block);
    printf("***********************************************************************************\n");
    printf("#%u: Status: %08x MsgCnt: %u\n", cpuId, ftmStatus, (ftmStatus >> 16));
    printf("-----------------------------------------------------------------------------------\n");
    if(ftmStatus & STAT_RUNNING)    printf("RUNNING  \t");  else printf("    -    \t");
    if(ftmStatus & STAT_IDLE)       printf("IDLE     \t");  else printf("    -    \t");
    if(ftmStatus & STAT_STOP_REQ)   printf("STOP_REQ \t");  else printf("    -    \t");
    if(ftmStatus & STAT_ERROR)      printf("ERROR    \t");  else printf("    -    \t");
    if(ftmStatus & STAT_WAIT)       printf("WAIT_COND\t");  else printf("    -    \t");
    printf("\n");
}

static void hexDump (char *desc, void *addr, int len) {
    int i;
    unsigned char buff[17];
    unsigned char *pc = (unsigned char*)addr;

    // Output description if given.
    if (desc != NULL)
        printf ("%s:\n", desc);

    // Process every byte in the data.
    for (i = 0; i < len; i++) {
        // Multiple of 16 means new line (with line offset).

        if ((i % 16) == 0) {
            // Just don't print ASCII for the zeroth line.
            if (i != 0)
                printf ("  %s\n", buff);

            // Output the offset.
            printf ("  %04x ", i);
        }

        // Now the hex code for the specific character.
        printf (" %02x", pc[i]);

        // And store a printable ASCII character for later.
        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
            buff[i % 16] = '.';
        else
            buff[i % 16] = pc[i];
        buff[(i % 16) + 1] = '\0';
    }
}

int main(int argc, char** argv) {

   
   int opt;
   char *value_end;
   
   t_ftmPage* pPage = NULL;
   t_ftmPage* pNewPage = NULL;
   const char* netaddress, *command;
   uint8_t bufWrite[BUF_SIZE];
   //uint8_t* pBufWrite;

   uint8_t bufRead[BUF_SIZE];
   uint8_t* pBufRead = &bufRead[0];
   char filename[64];
   int cpuId;
   uint8_t firstCpu, lastCpu;
   
   //FILE *f;    
  
   cpuId     = 0;
   error     = 0;
   verbose   = 0;
   readonly  = 1;
   program = argv[0];
   uint32_t i;
   while ((opt = getopt(argc, argv, "x:c:vh")) != -1) {
      switch (opt) {
         case 'x':
                  i =0;
                  while(i<64 && (optarg[i] != '\0')) { filename[i] = optarg[i]; i++;}
                  filename[i] = '\0';
                  readonly = 0;
                  break;
         case 'c':
            cpuId = strtol(optarg, &value_end, 0);
            if (*value_end || cpuId < -1 ||cpuId > 32) {
              fprintf(stderr, "%s: invalid cpu id -- '%s'\n", program, optarg);
              error = 1;
            }
         break;
         case 'v':
            verbose = 1;
            break;
         
         

         case 'h':
            help();
            return 0;
         case ':':
         case '?':
            error = 1;
            break;
         default:
            fprintf(stderr, "%s: bad getopt result\n", program);
            return 1;
      }
   }

   if (error) return 1;

   if (optind >= argc) {
   fprintf(stderr, "%s: expecting one non-optional argument: <etherbone-device>\n", program);
   fprintf(stderr, "\n");
   help();
   return 1;
   }

   
   netaddress = argv[optind];
   printf("\n");
   


   if (optind+1 < argc) {
   command = argv[optind+1];
   } else {
   command = "status"; cpuId = -1;
   }
   
   ebRamOpen(netaddress, 0);
   ebRamClose();
   
   if(cpuId < 0) { firstCpu   = 0; 
                   lastCpu    = cpuQty-1;
                  } // bit wasteful but safer than self modifiying loop
   else { firstCpu = (uint8_t)cpuId; 
          lastCpu  = (uint8_t)cpuId;
        }    
   
   if (!strcasecmp(command, "status")) { printf("+++ FTM@%s Status +++\n", netaddress); }
   uint8_t k;
   for(k = firstCpu; k <= lastCpu; k++)
   {
      if(ebRamOpen(netaddress, k)) return 1;
    
  
      /* -------------------------------------------------------------------- */
     if (!strcasecmp(command, "status")) {
       
       //printf("EBM: \n”); 
       status(k);
     }

     /* -------------------------------------------------------------------- */
     else if (!strcasecmp(command, "run")) {
       
       if (verbose) {
         printf("Starting CPU %u\n", k);
       }
       eb_device_write(device, embeddedOffset + FTM_CMD_OFFSET, EB_BIG_ENDIAN | EB_DATA32, CMD_START, 0, eb_block);

     }
     
     else if (!strcasecmp(command, "stop")) {
       
       if (verbose) {
         printf("Requesting CPU %u to stop\n", k);
       }
       eb_device_write(device, embeddedOffset + FTM_CMD_OFFSET, EB_BIG_ENDIAN | EB_DATA32, CMD_STOP_REQ, 0, eb_block);
     }
     
     else if (!strcasecmp(command, "idle")) {
       
       if (verbose) {
         printf("Setting BP of CPU %u to idle\n", k);
       }
       eb_device_write(device, embeddedOffset + FTM_CMD_OFFSET, EB_BIG_ENDIAN | EB_DATA32, CMD_IDLE, 0, eb_block);

     }
     
     else if (!strcasecmp(command, "fstop")) {
       
       if (verbose) {
         printf("Forcing CPU %u to stop\n", k);
       }
       eb_device_write(device, embeddedOffset + FTM_CMD_OFFSET, EB_BIG_ENDIAN | EB_DATA32, CMD_STOP_NOW, 0, eb_block);
     } 
     
     else if (!strcasecmp(command, "reset")) {
       if (verbose) {
         printf("Resetting FTM CPU %u\n", k);
       }
       eb_device_write(device, embeddedOffset + FTM_CMD_OFFSET, EB_BIG_ENDIAN | EB_DATA32, CMD_RST, 0, eb_block);
     } 
     else if (!strcasecmp(command, "init")) {
       
       if (verbose) {
         printf("Loading Firmware to CPU %u\n", k);
       }
       //filename
       
     }
     else if (!strcasecmp(command, "swap")) {
       
       if (verbose) {
         printf("Swapping Active/Inactive page on CPU %u\n", k);
       }
       eb_device_write(device, embeddedOffset + FTM_CMD_OFFSET, EB_BIG_ENDIAN | EB_DATA32, CMD_PAGE_SWAP, 0, eb_block);

     } 
     
     else if (!strcasecmp(command, "show")) {
       
       if (verbose) {
         printf("Commanding FTM CPU %u to show FTM Data on console\n", k);
       }
       eb_device_write(device, embeddedOffset + FTM_CMD_OFFSET, EB_BIG_ENDIAN | EB_DATA32, CMD_SHOW_ACT, 0, eb_block);
       sleep(1); 
     } 
     
     else if ((!strcasecmp(command, "put")) || (!strcasecmp(command, "get"))) {
       if(!strcasecmp(command, "put")) {
          if(!readonly) {
            printf("Parsing %s ...", filename);
            pPage = parseXml(filename);
            printf("done.\n");
            if(verbose) showFtmPage(pPage);
            serPage (pPage, &bufWrite[0], FTM_SHARED_OFFSET, k);
            printf("Writing %u bytes FTM Data to 0x%08x...", ebRamWrite(&bufWrite[0], embeddedOffset + FTM_SHARED_OFFSET, BUF_SIZE), embeddedOffset + FTM_SHARED_OFFSET);
            printf("done.\n");
         } else fprintf(stderr, "No xml file specified\n");
      }

      printf("Reading %u bytes FTM Data ...", ebRamRead(embeddedOffset + FTM_SHARED_OFFSET, BUF_SIZE, pBufRead));
      printf("done.\n");
      //hexDump ("ReadBuf", &bufRead[0], BUF_SIZE);
      
      
      pNewPage = deserPage(calloc(1, sizeof(t_ftmPage)), &bufRead[0], FTM_SHARED_OFFSET);
      if(pNewPage != NULL)
      {  
         printf("Deserialization successful.\n\n");
         if(verbose || (!strcasecmp(command, "get")) ) showFtmPage(pNewPage);
      }   
      else printf("Deserialization FAILED! Corrupt/No Data ?\n");
    }   
    else  printf("Unknown command: %s\n", command);  
  
    ebRamClose();

   } 
	   
	   
   return 0;
}


#ifndef _EVENT_H_
#define _EVENT_H_

#include <stdlib.h>
#include <stdint.h>
#include "ftm_common.h"
#include "node.h"
#include "timeblock.h"
#include "visitor.h"




#define NO_SUCCESSOR -1
enum prio {NONE, LOW, HIGH, INTERLOCK};


class Event : public Node {


protected:  
  uint64_t tOffs;
  uint16_t flags;
  void serialiseB(itBuf ib);
  virtual void acceptVertex(Visitor& v) = 0;
  virtual void acceptEdge(Visitor& v)   = 0;

public:
  Event() {}
  Event(uint64_t tOffs, uint16_t flags) : tOffs(tOffs), flags(flags) {}
  virtual ~Event() {};
  uint64_t getTPeriod() { return -1;}
  uint64_t getTOffs() { return tOffs;}
  uint16_t getFlags() { return flags;}
  
  virtual void show(void) = 0;
  virtual void show(uint32_t cnt, const char* sPrefix) = 0;
  virtual void serialise(itBuf ib) = 0;


  
};

class TimingMsg : public Event {
  uint64_t id;
  uint64_t par;
  uint32_t tef;

public:
  TimingMsg(uint64_t tOffs, uint16_t flags, uint64_t id, uint64_t par, uint32_t tef) : Event (tOffs, flags), id(id), par(par), tef(tef) {}
  ~TimingMsg() {};
  uint64_t getTOffs() { return Event::getTOffs();}
  uint64_t getTPeriod() { return Event::getTPeriod();}
  uint16_t getFlags() { return Event::getFlags();} 
  uint64_t getId(){return id;}
  uint64_t getPar(){return par;}
  uint32_t getTef(){return tef;}

  void show(void);
  void show(uint32_t cnt, const char* sPrefix);
  void serialise(itBuf ib);
  virtual void acceptVertex(Visitor& v) override { v.visitVertex(*this); }
  virtual void acceptEdge(Visitor& v)   override { v.visitEdge(*this); }

};


class Command : public Event {
protected: 
  uint64_t tValid;
  void serialiseB(itBuf ib);

public:
  Command(uint64_t tOffs, uint16_t flags, uint64_t tValid) : Event (tOffs, flags), tValid(tValid) {}
  ~Command() {};
  uint64_t getTOffs() { return Event::getTOffs();}
  uint16_t getFlags() { return Event::getFlags();}
  uint64_t getTPeriod() { return Event::getTPeriod();}
  uint64_t getTValid(){ return tValid;}

  virtual void show(void);
  virtual void show(uint32_t cnt, const char* sPrefix);
  virtual void serialise(itBuf ib)      = 0;
	virtual void acceptVertex(Visitor& v) = 0;
  virtual void acceptEdge(Visitor& v)   = 0;
};


class Noop : public Command {
  uint16_t qty;

public:
  Noop(uint64_t tOffs, uint16_t flags, uint64_t tValid, uint16_t qty) : Command( tOffs,  flags,  tValid) , qty(qty) {}
  ~Noop() {};
  uint64_t getTOffs() { return Command::getTOffs();}
  uint64_t getTPeriod() { return Command::getTPeriod();}
  uint16_t getFlags() { return Command::getFlags();} 
  uint64_t getTValid(){ return Command::getTValid();}
  uint16_t getQty() { return qty;} 

  void show(void);
  void show(uint32_t cnt, const char* sPrefix);
  void serialise(itBuf ib);
  virtual void acceptVertex(Visitor& v) override { v.visitVertex(*this); }
  virtual void acceptEdge(Visitor& v)   override { v.visitEdge(*this); }
};

class Flow : public Command {
  uint16_t qty;
  TimeBlock *blNext;

public:
  Flow(uint64_t tOffs, uint16_t flags, uint64_t tValid, uint16_t qty, TimeBlock *blNext)
      : Command( tOffs,  flags,  tValid) , qty(qty), blNext(blNext) {}
  ~Flow() {};
  uint64_t getTOffs() { return Command::getTOffs();}
  uint64_t getTPeriod() { return Command::getTPeriod();}
  uint16_t getFlags() { return Command::getFlags();} 
  uint64_t getTValid(){ return Command::getTValid();}
  uint16_t getQty() { return qty;} 
  TimeBlock* getNext() { return blNext;}

  void show(void);
  void show(uint32_t cnt, const char* sPrefix);
  void serialise(itBuf ib);
  virtual void acceptVertex(Visitor& v) override { v.visitVertex(*this); }
  virtual void acceptEdge(Visitor& v)   override { v.visitEdge(*this); }
};

class Flush : public Command {
  bool qIl;
  bool qHi;
  bool qLo;
  uint8_t upToHi;
  uint8_t upToLo;  

;

public:
  Flush(uint64_t tOffs, uint16_t flags, uint64_t tValid, bool qIl, bool qHi, bool qLo ) 
        : Command( tOffs,  flags,  tValid) , qIl(qIl), qHi(qHi), qLo(qLo), upToHi(ACT_FLUSH_RANGE_ALL), upToLo(ACT_FLUSH_RANGE_ALL) {}
  Flush(uint64_t tOffs, uint16_t flags, uint64_t tValid, bool qIl, bool qHi, bool qLo, uint8_t upToHi, uint8_t upToLo) 
        : Command( tOffs,  flags,  tValid) , qIl(qIl), qHi(qHi), qLo(qLo), upToHi(upToHi), upToLo(upToLo) {}
  ~Flush() {};
  uint64_t getTOffs() { return Command::getTOffs();}
  uint64_t getTPeriod() { return Command::getTPeriod();}
  uint16_t getFlags() { return Command::getFlags();} 
  uint64_t getTValid(){ return Command::getTValid();}
  bool getFlushQil() { return qIl;}
  bool getFlushQhi() { return qHi;}
  bool getFlushQlo() { return qLo;}
  uint8_t getFlushQ() {return (uint8_t)((qIl << 2) | (qHi << 1) | (qLo << 0));}
  uint8_t getFlushUpToHi() {return upToHi;}
  uint8_t getFlushUpToLo() {return upToLo;} 


  void show(void);
  void show(uint32_t cnt, const char* sPrefix);
  void set(prio target, uint8_t upTo);
  void clear(prio target);
  void serialise(itBuf ib);
  virtual void acceptVertex(Visitor& v) override { v.visitVertex(*this); }
  virtual void acceptEdge(Visitor& v)   override { v.visitEdge(*this); }
};



#endif

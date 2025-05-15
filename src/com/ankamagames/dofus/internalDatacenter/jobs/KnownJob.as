package com.ankamagames.dofus.internalDatacenter.jobs
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class KnownJob implements IDataCenter
   {
      public var jobDescription:JobDescription;
      
      public var jobExperience:JobExperience;
      
      public var jobPosition:int;
      
      public function KnownJob()
      {
         super();
      }
   }
}


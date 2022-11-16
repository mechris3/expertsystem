import { NgModule } from '@angular/core';
import { StoreModule } from '@ngrx/store';
import { ACESSMReducer } from './redux/ace-ssm.reducer';
import { TaskStructureModule } from './taskStructure/task-structure.module';

@NgModule({
	imports: [
		StoreModule.forFeature('acessm', ACESSMReducer),
		TaskStructureModule
	],
	exports: [TaskStructureModule]
})

export class ACESSMSModule { }

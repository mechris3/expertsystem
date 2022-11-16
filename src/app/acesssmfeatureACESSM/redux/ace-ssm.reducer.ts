
import { Action, createFeatureSelector, createReducer, createSelector, on } from "@ngrx/store"
import { loadTaskStructure } from "./ace-ssm.actions";




export interface IEntity {
	name: string;
}

export interface IRelation {
	name: string;
	a: string;
	b: string;
}
export interface ITaskStructure {
	entities: Array<IEntity>;
	relations: Array<IRelation>;
}

export interface IACCSSM {
	taskStructure: ITaskStructure;
}

const initialState: IACCSSM = {
	taskStructure: {
		entities: [
			{
				name: 'organ-system'
			},
			{
				name: 'etiologic-agent'
			},
			{
				name: 'disease'
			},
			{
				name: 'entry-point'
			},
			{
				name: 'finding'
			},
			{
				name: 'question'
			}],
		relations: [
			{
				name: 'subsumes',
				a: 'organ-system',
				b: 'organ-system'
			},
			{
				name: 'resides-in',
				a: 'etiologic-agent',
				b: 'organ-system'
			},
			{
				name: 'subtype',
				a: 'etiologic-agent',
				b: 'etiologic-agent'
			},
			{
				name: 'induces',
				a: 'etiologic-agent',
				b: 'disease'
			},
			{
				name: 'causes',
				a: 'disease',
				b: 'finding'
			},
			{
				name: 'causes',
				a: 'disease',
				b: 'disease'
			},
			{
				name: 'subtype',
				a: 'disease',
				b: 'disease'
			},
			{
				name: 'subtype',
				a: 'finding',
				b: 'finding'
			},
			{
				name: 'subsumes',
				a: 'finding',
				b: 'finding'
			},
			{
				name: 'confirms',
				a: 'question',
				b: 'finding'
			},
			{
				name: 'confirms',
				a: 'finding',
				b: 'entry-point'
			},
			{
				name: 'enters',
				a: 'etiologic-agent',
				b: 'entry-point'
			}
		]
	}
}

export const getACESSMState = createFeatureSelector<IACCSSM>('acessm');
export const getTaskStructure = createSelector(getACESSMState, state => state.taskStructure);
export const getEntities = createSelector(getTaskStructure, state => state.entities);
export const getRelations = createSelector(getTaskStructure, state => state.relations);

const _ACESSMReducer = createReducer(
	initialState,
	on(loadTaskStructure, (state: IACCSSM, action: Action) => state)
);

export function ACESSMReducer(state: IACCSSM, action: Action): IACCSSM {
	return _ACESSMReducer(state, action);
}

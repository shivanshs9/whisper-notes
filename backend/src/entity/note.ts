import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from "typeorm"

function columnTypeTimestamp() {
    return process.env.DB_USERNAME ? 'timestamp' : 'bigint'
 }

@Entity()
export class Note {
    @PrimaryGeneratedColumn()
    id!: number

    @Column()
    public transcription!: string

    @CreateDateColumn({ type: columnTypeTimestamp() })
    public createdAt!: Date;
}

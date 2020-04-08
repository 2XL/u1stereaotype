2) los updates por file category

	-- when operation is sync
	-- node_id, user_id, ext




	-- edits by file category
	


 





select profile, category, count(*) hit from traces_2w.traces_2w_3k_master m 
inner join u1fitting.file_ext_category c
on m.node_id = c.node_id
where req_t = "SYNC" 
group by profile, category
order by profile, category
